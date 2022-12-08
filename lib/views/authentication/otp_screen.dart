import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hms_models/hms_models.dart';
import 'package:hms_models/utils/my_safe_state.dart';
import 'package:hms_models/utils/my_toast.dart';
import 'package:patient/configs/app_strings.dart';
import 'package:patient/controllers/authentication_controller.dart';
import 'package:patient/providers/authentication_provider.dart';
import 'package:patient/views/common/components/loading_widget.dart';
import 'package:provider/provider.dart';

import '../../controllers/connection_controller.dart';
import '../../controllers/my_patient_controller.dart';
import '../common/components/modal_progress_hud.dart';
import '../common/components/pin_put.dart';
import '../homescreen/screens/homescreen.dart';

class OtpScreen extends StatefulWidget {
  final String mobile;
  static const String routeName = "/OtpScreen";

  const OtpScreen({Key? key, required this.mobile}) : super(key: key);

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> with MySafeState {
  TextEditingController? _otpController;
  FocusNode? _otpFocusNode;
  CountDownController? controller;

  late ThemeData themeData;
  bool isInVerification = false;
  String msg = "", otpErrorMsg = "";
  bool msgshow = false,
      isShowOtpErrorMsg = false,
      isOTPTimeout = false,
      isShowResendOtp = false,
      isLoading = false,
      isOTPSent = false,
      isOtpEnabled = false,
      isTimerOn = false,
      isOtpSending = false;
  String? verificationId;

  double otpDuration = 120.0;

  Future registerUser(String mobile) async {
    print("Register User Called for mobile:$mobile");

    try {} catch (e) {
      //_controller.restart();
    }

    changeMsg("Please wait ! \nOTP is on the way.");

    FirebaseAuth auth = FirebaseAuth.instance;
    //String otp = "";

    isOTPTimeout = false;
    isOTPSent = false;
    isOtpEnabled = false;
    isOtpSending = true;
    _otpController!.text = "";
    mySetState();

    auth.verifyPhoneNumber(
      phoneNumber: "+91$mobile",
      timeout: Duration(seconds: otpDuration.toInt()),
      verificationCompleted: (AuthCredential credential) {
        print("Automatic Verification Completed");
        MyToast.showSuccess(msg:"OTPcontext: Fetched Successfully", context: context);

        verificationId = null;
        isOTPSent = false;
        isShowResendOtp = false;
        isOtpEnabled = false;
        isOtpSending = false;
        isOTPSent = false;
        otpErrorMsg = "";
        isLoading = true;
        mySetState();
        changeMsg("Now, OTP received.\nSystem is preparing to login.");
        auth.signInWithCredential(credential)
        .then((UserCredential credential) async {
          // AnalyticsController().fireEvent(analyticEvent: AnalyticsEvent.phone_verification_success);
          if(credential.user != null) {
            await onSuccess(credential.user!);
          }
        }).catchError((e) {
          print(e);
          // AnalyticsController().fireEvent(analyticEvent: AnalyticsEvent.phone_verification_failed);
        });
      },
      verificationFailed: (FirebaseAuthException e) {
        print("Error in Automatic OTP Verification:${e.message!}");
        verificationId = null;
        changeMsg("Error in Automatic OTP Verification:${e.code}");
        isShowResendOtp = true;
        isOTPTimeout = true;
        isOtpEnabled = false;
        isOtpSending = false;
        isOTPSent = false;
        otpErrorMsg = "";
        isTimerOn = false;

        //_otpController?.text = "";
        mySetState();
        MyToast.normalMsg(msg:e.message ?? AppStrings.try_again,context: context);
        // AnalyticsController().fireEvent(analyticEvent: AnalyticsEvent.phone_verification_failed);
        //_otpController?.text = "";
      },
      codeSent: (verificationId, [forceResendingToken]) {
        print("OTP Sent");
        MyToast.showSuccess(msg:AppStrings.otp_sent,context: context);
        //MyToast.showSuccess("msg:OTP sent to yourcontext: mobile", context);
        this.verificationId = verificationId;
        // istimer = true;
        //_otpController?.text = "";
        otpErrorMsg = "";

        isOTPSent = true;
        isTimerOn = true;
        isShowResendOtp = true;
        isOtpEnabled = true;
        isOtpSending = false;
        mySetState();

        //startTimer();

        _otpFocusNode?.requestFocus();

        //_smsReceiver.startListening();

        changeMsg("OTP Sent!");

        // AnalyticsController().fireEvent(analyticEvent: AnalyticsEvent.phone_verification_started);
      },
      codeAutoRetrievalTimeout: onOtpTimeout,
    );
  }

  void onOtpTimeout(String value) {
    print("Automatic Verification Timeout");

    verificationId = null;
    //_otpController?.text = "";
    isOTPTimeout = true;
    isShowResendOtp = true;
    msg = "Timeout";
    isOtpEnabled = false;
    isOtpSending = false;
    isOTPSent = false;
    otpErrorMsg = "";
    isTimerOn = false;
    if(mounted) {
      MyToast.showError(msg:AppStrings.try_again,context: context);
      // AnalyticsController().fireEvent(analyticEvent: AnalyticsEvent.phone_verification_failed);
      mySetState();
    }
  }

  //Here otp is the code recieved in text message
  //verificationId is code we get in codeSent method of _auth.verifyPhoneNumber()
  //Method prints String "Verification Successful" if otp verified successfully
  //Method prints String "Verification Failed" if otp verification fails
  Future<bool> verifyOTP({@required String? otp, @required String? verificationId}) async {
    print("Verify OTP Called");

    isLoading = true;
    mySetState();

    try {
      print("OTP Entered To Verify:${otp!}");
      //print("VerificationId:"+verificationId);
      FirebaseAuth auth = FirebaseAuth.instance;

      AuthCredential authCredential = PhoneAuthProvider.credential(
          verificationId: verificationId!, smsCode: otp);
      UserCredential userCredential = await auth.signInWithCredential(authCredential);

      changeMsg("OTP Verified!\nTaking to homepage.");

      // AnalyticsController().fireEvent(analyticEvent: AnalyticsEvent.phone_verification_success);
      await onSuccess(userCredential.user!);

      isShowOtpErrorMsg = false;
      isLoading = false;
      mySetState();

      return true;
    } on FirebaseAuthException catch (e) {
      print("Error in Verifying OTP in Auth_Service:${e.code}");

      if (e.code == "invalid-verification-code") {
        MyToast.showError(msg:AppStrings.wrong_otp,context: context);
      }

      otpErrorMsg = e.message!;
      isShowOtpErrorMsg = true;
      // AnalyticsController().fireEvent(analyticEvent: AnalyticsEvent.phone_verification_failed);

      isLoading = false;
      mySetState();

      return false;
    }
  }

  Future<void> onSuccess(User user) async {
    AuthenticationProvider authenticationProvider = Provider.of<AuthenticationProvider>(context, listen: false);
    MyPrint.printOnConsole("user.phoneNumber:${user.phoneNumber}");
    if((user.phoneNumber ?? "").isNotEmpty) {
      authenticationProvider.setFirebaseUser(user, isNotify: false);
      authenticationProvider.setUserId(user.uid, isNotify: false);
      authenticationProvider.setMobileNumber(user.phoneNumber ?? "", isNotify: false);
      await MyPatientController().getPatientsDataForMainPage();
      Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName, (route) => false);
    }
    else {
      AuthenticationController().logout(context: context, isNavigateToLogin: true);
    }
  }

  void changeMsg(String m) async {
    msg = m;
    msgshow = true;
    mySetState();
    /*await Future.delayed(Duration(seconds: 5));
    setState(() {
      msgshow = false;
    });*/
  }

  bool checkEnabledVerifyButton() {
    if (_otpController?.text.length == 6) {
      return true;
    } else {
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    _otpController = TextEditingController();
    _otpFocusNode = FocusNode();

    _otpFocusNode!.requestFocus();
    controller = CountDownController();

    // AnalyticsController().analytics.setCurrentScreen(screenName: OtpScreen.routeName, screenClassOverride: "OtpScreen");
    registerUser(widget.mobile);
  }

  @override
  void dispose() {
    try {
      _otpController!.dispose();
      _otpFocusNode!.dispose();
    }
    catch (e) {}
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: ModalProgressHUD(
          inAsyncCall: isLoading,
          progressIndicator: const LoadingWidget(),
          child: Container(
            padding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 20,
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  getAppBar(),
                  const SizedBox(
                    height: 40,
                  ),
                  getText1(),
                  const SizedBox(
                    height: 6,
                  ),
                  getText3(),
                  const SizedBox(
                    height: 18,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      getOtpWidget(),
                      const SizedBox(
                        height: 20,
                      ),
                      // getResendLinkWidget(),
                    ],
                  ),
                  /*SizedBox(
                    height: MySize.size40!,
                  ),
                  getMessageText(msg),*/
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Visibility(
                        visible: isOtpSending && !isOTPSent,
                        child: const LoadingWidget(
                          boxSize: 50,
                          loaderSize: 40,
                        ),
                      ),
                    ],
                  ),
                  getTimer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      getResendLinkWidget(),
                    ],
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      getSubmitButton(),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget getAppBar() {
    return Row(
      children: [
        InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          splashColor: Colors.red,
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              Icons.arrow_back_ios,
              color: themeData.colorScheme.primary,
            ),
          ),
        ),
      ],
    );
  }

  Widget getText1() {
    return Text(
      "Enter your OTP.",
      style: themeData.textTheme.headline6?.copyWith(
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget getText3() {
    return Text(
      "If you don't receive otp then use resend option.",
      style: themeData.textTheme.caption?.copyWith(
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget getOtpWidget() {
    BoxDecoration pinPutDecoration = BoxDecoration(
      color: themeData.colorScheme.primary.withAlpha(10),
      border: Border.all(color: themeData.colorScheme.primary),
      borderRadius: BorderRadius.circular(5),
    );

    /*BoxDecoration _disabledPinPutDecoration = BoxDecoration(
      border: Border.all(color: Styles.blue),
      borderRadius: BorderRadius.circular(MySize.size5!),
    );*/

    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      //color: Colors.red,
      child: PinPut(
        fieldsCount: 6,
        onSubmit: (String pin) {
          print("Submitted:$pin");
          _otpFocusNode!.unfocus();
        },
        checkClipboard: true,
        onClipboardFound: (String? string) {
          _otpController!.text = string ?? "";
        },
        inputFormatters: [
          FilteringTextInputFormatter.deny(" "),
          FilteringTextInputFormatter.digitsOnly,
        ],
        enabled: true,
        focusNode: _otpFocusNode,
        controller: _otpController,
        eachFieldWidth: 50,
        eachFieldHeight: 50,
        submittedFieldDecoration: pinPutDecoration,
        selectedFieldDecoration: pinPutDecoration,
        disabledDecoration: pinPutDecoration,
        followingFieldDecoration: pinPutDecoration.copyWith(
          borderRadius: BorderRadius.circular(5.0),
          border: Border.all(
            color: themeData.colorScheme.primary,
            // color: themeData.colorScheme.onPrimary,
          ),
        ),
        inputDecoration: const InputDecoration(
          border: OutlineInputBorder(borderSide: BorderSide.none),
          disabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
          errorBorder: OutlineInputBorder(borderSide: BorderSide.none),
          focusedBorder: OutlineInputBorder(borderSide: BorderSide.none),
          enabledBorder: const OutlineInputBorder(borderSide: BorderSide.none),
          focusedErrorBorder: const OutlineInputBorder(borderSide: BorderSide.none),
        ),
        //disabledDecoration: _pinPutDecoration,
        textStyle: themeData.textTheme.caption?.copyWith(
          fontWeight: FontWeight.bold,
          fontSize: 15,
        ),
      ),
    );

    /*return Container(
      child: Row(
        children: [
          getSingleOtpField(controller: _otp1Controller!, focusNode: _otp1FocusNode!),
          SizedBox(width: MySize.size20!,),
          getSingleOtpField(controller: _otp2Controller!, focusNode: _otp2FocusNode!),
          SizedBox(width: MySize.size20!,),
          getSingleOtpField(controller: _otp3Controller!, focusNode: _otp3FocusNode!),
          SizedBox(width: MySize.size20!,),
          getSingleOtpField(controller: _otp4Controller!, focusNode: _otp4FocusNode!),
        ],
      ),
    );*/
  }

  Widget getResendLinkWidget() {
    if (!isOTPTimeout) return const SizedBox.shrink();

    return InkWell(
      onTap: () {
        registerUser(widget.mobile ?? "");
      },
      child: Container(
        margin: const EdgeInsets.only(top: 15),
        child: Text(
          "RESEND OTP",
          style: themeData.textTheme.caption?.copyWith(
            fontWeight: FontWeight.bold,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }

  Widget getSubmitButton() {
    return InkWell(
      onTap: () async {
        // Navigator.pushNamed(context, SignUpScreen1.routeName);
        FocusScope.of(context).requestFocus(new FocusNode());
        print("hello o");

        //ConnectionProvider connectionProvider = Provider.of<ConnectionProvider>(context, listen: false);
        if(!(isOtpSending && !isOTPSent)){
          if(ConnectionController().checkConnection(context: context)) {
            print("three");
            if (isOTPSent) {
              print("four");
              if (!checkEnabledVerifyButton()) {
                MyPrint.printOnConsole("Invalid Otp");
                isShowOtpErrorMsg = true;
                otpErrorMsg = "OTP should be of 6 digits";
                mySetState();
              }
              else {
                MyPrint.printOnConsole("Valid Otp");
                isShowOtpErrorMsg = false;
                otpErrorMsg = "";
                mySetState();
                print("one");
                if (verificationId != null) {
                  String? otp = _otpController?.text;
                  print("two");
                  /*bool result = */await verifyOTP(otp: otp, verificationId: verificationId);
                }
                else {
                  print("five");
                  MyToast.showError(msg:AppStrings.otp_expired_please_resend,context: context);
                }
              }
            }
            else{
              print("seven");
              MyToast.showError(msg:AppStrings.otp_expired_please_resend,context: context);
            }
          }
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        decoration: BoxDecoration(
            color: themeData.colorScheme.primary,
            borderRadius: const BorderRadius.all(Radius.circular(5)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Submit',
              style: themeData.textTheme.caption?.copyWith(
                fontWeight: FontWeight.w600,
                color: themeData.colorScheme.onPrimary,
                fontSize: 15,
              ),
            ),
            const SizedBox(
              width: 12,
            ),
            const Icon(
              Icons.arrow_forward,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget getMobileNumberText(String mobile) {
    return Text(
      "+91-$mobile",
      style: themeData.textTheme.bodyText2?.copyWith(
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget getLoadingWidget(bool isLoading) {
    return Column(
      children: [
        Visibility(
          visible: isLoading,
          child: CircularProgressIndicator(
            color: themeData.colorScheme.primary,
            strokeWidth: 4,
          ),
        ),
        Visibility(
          visible: isLoading,
          child: const SizedBox(
            height: 30,
          ),
        )
      ],
    );
  }

  Widget getMessageText(String text) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Visibility(
        visible: msgshow,
        child: Text(
          text,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget getTimer() {
    if (!isTimerOn) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: CircularCountDownTimer(
        controller: controller,
        width: 100,
        height: 100,
        duration: otpDuration.toInt(),
        initialDuration: 0,
        ringColor: isTimerOn ? themeData.colorScheme.primary.withAlpha(100) : Colors.white,
        fillColor: themeData.colorScheme.primary,
        isReverse: true,
        isReverseAnimation: true,
        textStyle: themeData.textTheme.bodyText2?.copyWith(
          fontWeight: FontWeight.w700,
        ),
        strokeWidth: 5,
        textFormat: "mm:ss",
        strokeCap: StrokeCap.round,
        onComplete: () {
          /*isTimerOn = false;
          if (mounted) setState(() {});*/

          Future.delayed(const Duration(milliseconds: 500), () {
            if(isTimerOn) {
              onOtpTimeout("");
            }
          });
        },
      ),
    );
  }

  Widget getOtpErrorMessageText(String text) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Visibility(
        visible: isShowOtpErrorMsg,
        child: Text(
          text,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget getOtp1Widget() {
    return Container(
      height: 48,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      color: Colors.transparent,
      child: TextFormField(
        /*controller: _otpController,
        focusNode: _otpFocusNode,
        onChanged: (val) {
          if(val.length == 6) _otpFocusNode?.unfocus(disposition: UnfocusDisposition.scope);
        },*/
        enabled: isOtpEnabled,
        textAlign: TextAlign.center,
        decoration: const InputDecoration(
          helperText: "",
        ),
        inputFormatters: [
          LengthLimitingTextInputFormatter(6),
          FilteringTextInputFormatter.digitsOnly,
        ],
        keyboardType: TextInputType.number,
        maxLines: 1,
        style: const TextStyle(letterSpacing: 3),
      ),
    );
  }

  Widget getResendButtonAndTimer() {
    if (isShowResendOtp) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          isOTPTimeout
              //Resend Button
              ? Visibility(
                  visible: isOTPTimeout,
                  child: GestureDetector(
                    onTap: () {
                      registerUser(widget.mobile ?? "");
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 32),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(
                          color: Colors.green,
                          style: BorderStyle.solid,
                          width: 1,
                        ),
                      ),
                      child: const Text(
                        "Resend OTP",
                      ),
                    ),
                  ),
                  /*child: OutlineButton(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 32),
                    borderSide: BorderSide(
                      color: Styles.green,
                      style: BorderStyle.solid,
                      width: 1,
                    ),
                    color: Colors.transparent,
                    splashColor: Colors.white,
                    onPressed: () {
                      registerUser(widget.mobile!);
                    },
                    child: Text(
                      "Resend OTP",
                    ),
                  ),*/
                )
              //Timer
              : Visibility(
                  visible: !isOTPTimeout,
                  child: Row(
                    children: [
                      const Text(
                        "Resend in ",
                      ),
                      TweenAnimationBuilder(
                        tween: Tween(begin: otpDuration, end: 0.0),
                        duration: Duration(seconds: otpDuration.toInt()),
                        builder: (BuildContext context, double value,
                            Widget? child) {
                          int minutes = Duration(seconds: value.toInt()).inMinutes;
                          int remainingSeconds = value.toInt() - (minutes * 60);

                          //NumberFormat numberFormat = NumberFormat("##");

                          return Text(
                            "$minutes : $remainingSeconds",
                          );
                        },
                      ),
                    ],
                  ),
                ),
        ],
      );
    }
    else {
      return const Spacer();
    }
  }
}

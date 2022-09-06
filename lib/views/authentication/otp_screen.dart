import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:patient/controllers/authentication_controller.dart';
import 'package:patient/providers/authentication_provider.dart';
import 'package:provider/provider.dart';

import '../../configs/app_theme.dart';
import '../../providers/connection_provider.dart';
import '../../utils/logger_service.dart';
import '../../utils/my_toast.dart';
import '../homescreen/homescreen.dart';

class OtpScreen extends StatefulWidget {
  final String mobile;
  static const String routeName = "/OtpScreen";

  const OtpScreen({Key? key, required this.mobile}) : super(key: key);

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  bool pageMounted = false;

  late TextEditingController _numberController, _otpController;
  late FocusNode _otpFocusNode;

  late ThemeData themeData;
  bool isInVerification = false;
  String msg = "", otpErrorMsg = "";
  bool msgshow = false, isShowOtpErrorMsg = false, isOTPTimeout = false, isShowResendOtp = false, isLoading = false, isOTPSent = false, isOtpEnabled = false;
  String? verificationId;

  double otpDuration = 120.0;

  void mySetState() {
    if(mounted) {
      if(pageMounted) {
        setState(() {});
      }
      else {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          setState(() {});
        });
      }
    }
  }

  Future registerUser(String mobile) async {

    print("Register User Called for mobile:" + mobile);

    try {} catch (e) {
      //_controller.restart();
    }

    changeMsg("Please wait ! \nOTP is on the way.");

    FirebaseAuth _auth = FirebaseAuth.instance;
    String otp = "";

    isLoading = true;
    isOTPTimeout = false;
    isOTPSent = false;
    isOtpEnabled = false;
    mySetState();

    _auth.verifyPhoneNumber(
        phoneNumber: mobile,
        timeout: Duration(seconds: otpDuration.toInt()),
        verificationCompleted: (AuthCredential _credential) {
          print("Automatic Verification Completed");

          verificationId = null;
          isOTPSent = false;
          isShowResendOtp = false;
          isOtpEnabled = false;
          otpErrorMsg = "";
          mySetState();

          changeMsg("Now, OTP received.\nSystem is preparing to login.");
          _auth.signInWithCredential(_credential).then((UserCredential credential) async {
            if(credential.user != null) await onSuccess(credential.user!);
          })
              .catchError((e) {
            print(e);
          });
        },
        verificationFailed: (FirebaseAuthException e) {
          print("Error in Automatic OTP Verification:${e.message}");

          verificationId = null;
          changeMsg("Error in Automatic OTP Verification:"+e.code);
          isShowResendOtp = true;
          isOTPTimeout = true;
          isLoading = false;
          isOtpEnabled = false;
          otpErrorMsg = "";

          _otpController.text = "";
          mySetState();
          //MyToast.showError("Try Again!", context);
        },
        codeSent: (verificationId, [forceResendingToken]) {
          print("OTP Sent");
          //MyToast.showSuccess("Please wait, OTP sent to your mobile", context);
          this.verificationId = verificationId;
          // istimer = true;
          _otpController.text = "";
          otpErrorMsg = "";

          isOTPSent = true;
          isShowResendOtp = true;
          isOtpEnabled = true;
          mySetState();

          _otpFocusNode.requestFocus();

          //_smsReceiver.startListening();

          changeMsg("OTP Sent!");
        },
        codeAutoRetrievalTimeout: (val) {
          print("Automatic Verification Timeout");
          isLoading = false;
          verificationId = null;
          _otpController.text = "";
          isOTPTimeout = true;
          isShowResendOtp = true;
          msg = "Timeout";
          isOtpEnabled = false;
          otpErrorMsg = "";
          mySetState();
          //MyToast.normalMsg("Try Again!", context);
        }
    );
  }

  //Here otp is the code recieved in text message
  //verificationId is code we get in codeSent method of _auth.verifyPhoneNumber()
  //Method prints String "Verification Successful" if otp verified successfully
  //Method prints String "Verification Failed" if otp verification fails
  Future<bool> verifyOTP({required String otp, required String verificationId}) async {
    print("Verify OTP Called");

    try {

      print("OTP Entered To Verify:"+otp);
      //print("VerificationId:"+verificationId);
      FirebaseAuth _auth = FirebaseAuth.instance;

      AuthCredential authCredential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: otp);
      UserCredential userCredential = await _auth.signInWithCredential(authCredential);

      changeMsg("OTP Verified!\nTaking to homepage.");

      if(userCredential.user != null) await onSuccess(userCredential.user!);

      isShowOtpErrorMsg = false;
      mySetState();

      return true;
    }
    on PlatformException catch(pe) {
      print("PlatformException in Verifying OTP in Auth_Service:"+pe.code);

      otpErrorMsg = pe.message ?? "";
      isShowOtpErrorMsg = true;
      mySetState();

      return false;
    }
    catch(e) {
      print("Error in Verifying OTP in Auth_Service:");

      return false;
    }
  }

  Future<void> onSuccess(User user) async {
    AuthenticationProvider authenticationProvider = Provider.of<AuthenticationProvider>(context, listen: false);
    Log().i("user.phoneNumber:${user.phoneNumber}");
    if((user.phoneNumber ?? "").isNotEmpty) {
      authenticationProvider.setFirebaseUser(user, isNotify: false);
      authenticationProvider.setUserId(user.uid, isNotify: false);
      authenticationProvider.setMobileNumber(user.phoneNumber ?? "", isNotify: false);
      Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName, (route) => false);
    }
    else {
      AuthenticationController().logout(context: context, isNavigateToLogin: true);
    }
  }

  @override
  void initState() {
    pageMounted = false;
    super.initState();
    _numberController = TextEditingController(text: "+91 ");
    _otpController = TextEditingController();
    _otpFocusNode = FocusNode();

    registerUser("+91 " + widget.mobile);
  }

  @override
  void dispose() {
    pageMounted = false;
    super.dispose();
    try {
      _numberController.dispose();
      _otpController.dispose();
      _otpFocusNode.dispose();
    }
    catch(e) {

    }
  }

  @override
  Widget build(BuildContext context) {
    pageMounted = false;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      pageMounted = true;
    });

    themeData = Theme.of(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: themeData.colorScheme.background,
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            /*MyAppBar(
              title: "",
              color: Provider.of<AppThemeNotifier>(context).themeMode() == AppTheme.themeDark ? Colors.black : Colors.white,
              backbtncallback: () {
              Navigator.pop(context);
              },
            ),*/
            Expanded(
                child: Container(
                  padding: EdgeInsets.only(bottom: 16, top: 8, left: 50, right: 50),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 50,),
                        getLogo(),
                        getMobileNumberText(widget.mobile),
                        SizedBox(height: 50,),

                        getLoadingWidget(isLoading),
                        getMessageText(msg),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            getOtpWidget(),
                            getOtpErrorMessageText(otpErrorMsg),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                getResendButtonAndTimer(),
                                getVerifyButton(),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
            )
          ],
        ),
      ),
    );
  }

  Widget getLogo() {
    return Container(
      margin: EdgeInsets.only(bottom: 34),
      width: 100,
      height: 100,
      child: Image.asset("assets/logo2.png"),
    );
  }

  Widget getMobileNumberText(String mobile) {
    return Text(
      "+91-$mobile",
      style: AppTheme.getTextStyle(themeData.textTheme.headline6!,
          fontWeight: FontWeight.w500,
          color: themeData.appBarTheme.iconTheme!.color),
    );
  }

  Widget getLoadingWidget(bool isLoading) {
    return Column(
      children: [
        Visibility(
          visible: isLoading,
          child: SpinKitRing(color: themeData.colorScheme.primary,lineWidth: 4,),
        ),
        Visibility(
          visible: isLoading,
          child: SizedBox(height: 30,),
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
          style: AppTheme.getTextStyle(themeData.textTheme.headline6!,
              fontWeight: FontWeight.w500,
              color: themeData.appBarTheme.iconTheme!.color),
          textAlign: TextAlign.center,
        ),
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
          style: AppTheme.getTextStyle(
              themeData.textTheme.subtitle2!,
              fontWeight: FontWeight.w500,
              color: Colors.red,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget getOtpWidget() {
    return Container(
      height: 48,
      margin: EdgeInsets.symmetric(horizontal: 4),
      color: Colors.transparent,
      child: TextFormField(
        controller: _otpController,
        focusNode: _otpFocusNode,
        onChanged: (val) {
          if(val.length == 6) _otpFocusNode.unfocus(disposition: UnfocusDisposition.scope);
        },
        enabled: isOtpEnabled,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          border: UnderlineInputBorder(
              borderSide: BorderSide(
                  width: 2,
                  color: themeData
                      .inputDecorationTheme.border!.borderSide.color)),
          enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                  width: 2,
                  color: themeData
                      .inputDecorationTheme.enabledBorder!.borderSide.color)),
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                  width: 2,
                  color: themeData
                      .inputDecorationTheme.focusedBorder!.borderSide.color)),
          helperText: "",
        ),
        inputFormatters: [
          LengthLimitingTextInputFormatter(6),
          FilteringTextInputFormatter.digitsOnly,
        ],
        keyboardType: TextInputType.number,
        maxLines: 1,
        style: TextStyle(letterSpacing: 3),
      ),
    );
  }

  Widget getResendButtonAndTimer() {
    if(isShowResendOtp) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[

          isOTPTimeout
          //Resend Button
              ?  Visibility(
                  visible: isOTPTimeout,
                  child: FlatButton(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 32),
                    /*border: Border.all(
                      color: themeData.colorScheme.secondary,
                      style: BorderStyle.solid,
                      width: 1,
                    ),*/
                    color: Colors.transparent,
                    splashColor: Colors.white,
                    onPressed: () {
                      registerUser("+91 " + widget.mobile);
                    },
                    child: Text(
                      "Resend OTP",
                      style: AppTheme.getTextStyle(
                        themeData.textTheme.bodyText2!,
                        fontWeight: FontWeight.w600,
                        color:
                        themeData.colorScheme.onBackground,
                      ),
                    ),
                  ),
                )
          //Timer
              :  Visibility(
            visible: !isOTPTimeout,
            child: Row(
              children: [
                Text(
                  "Resend in ",
                  style: AppTheme.getTextStyle(
                    themeData.textTheme.caption!,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.2,
                  ),
                ),
                /*Text(
              "00:59",
              style: AppTheme.getTextStyle(
                  themeData.textTheme.caption,
                  fontWeight: 500,
              ),
            ),*/
                TweenAnimationBuilder(
                  tween: Tween(begin: otpDuration, end: 0.0),
                  duration: Duration(seconds: otpDuration.toInt()),
                  builder: (BuildContext context ,double value, Widget? child) {

                    int minutes = Duration(seconds: value.toInt()).inMinutes;
                    int remainingSeconds = value.toInt() - (minutes * 60);

                    // NumberFormat numberFormat = NumberFormat("##");

                    return Text(
                      "${minutes} : ${remainingSeconds}",
                      style: AppTheme.getTextStyle(
                        themeData.textTheme.caption!,
                        fontWeight: FontWeight.w500,
                      ),
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
      return Spacer();
    }
  }

  Widget getVerifyButton() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        boxShadow: [
          BoxShadow(
            color: themeData.colorScheme.primary
                .withAlpha(24),
            blurRadius: 3,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: FlatButton(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 32,),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4),),
        color: themeData.colorScheme.primary,
        splashColor: Colors.white.withAlpha(150),
        highlightColor: themeData.colorScheme.primary,
        onPressed: () async {
          ConnectionProvider connectionProvider = Provider.of<ConnectionProvider>(context, listen: false);

          if(connectionProvider.isInternet) {
            if(isOTPSent) {
              if(!checkEnabledVerifyButton()) {
                Log().i("Invalid Otp");
                isShowOtpErrorMsg = true;
                otpErrorMsg = "OTP should be of 6 digits";
                mySetState();
              }
              else {
                Log().i("Valid OTP");
                isShowOtpErrorMsg = false;
                otpErrorMsg = "";
                mySetState();

                if(verificationId != null) {
                  String otp = _otpController.text;

                  bool result = await verifyOTP(otp: otp, verificationId: verificationId!);
                }
              }
            }
          }
          else MyToast.showError("No Internet", context);
        },
        child: Text(
          "Verify",
          style: AppTheme.getTextStyle(
            themeData.textTheme.bodyText2!,
            fontWeight: FontWeight.w600,
            color: themeData.colorScheme.onPrimary,
          ),
        ),
      ),
    );
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
    if(_otpController.text.length  == 6) {
      return true;
    }
    else {
      return false;
    }
  }
}

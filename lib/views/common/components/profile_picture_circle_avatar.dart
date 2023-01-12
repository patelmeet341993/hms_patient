import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../../configs/styles.dart';

class ProfilePictureCircleAvatar extends StatelessWidget {
  final String imageUrl;
  final double height;
  final double width;
  final double borderRadius;
  final Color borderColor;
  final double borderWidth;
  final void Function()? onTap;

  const ProfilePictureCircleAvatar({
    required this.imageUrl,
    this.borderRadius= 50,
    this.width=50,
    this.height=50,
    this.borderColor=Styles.lightPrimaryColor,
    this.borderWidth=1,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // MyPrint.printOnConsole("Widget.Image Url in Profile Circle:${widget.imageUrl}, with feed id:${widget.feedModel?.id}");
    // MyPrint.printOnConsole("Image Url in Profile Circle:$imageUrl, with feed id:${widget.feedModel?.id}");

    return  InkWell(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: borderColor, width: borderWidth),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: imageUrl.isNotEmpty ? CachedNetworkImage(
            imageUrl: imageUrl,
            fit: BoxFit.fill,
            placeholder: (context, _) {
              return Shimmer.fromColors(
                baseColor: Styles.shimmerBaseColor,
                highlightColor: Styles.shimmerHighlightColor,
                child: Container(
                  alignment: Alignment.center,
                  color: Styles.shimmerContainerColor,
                  child: Icon(
                    Icons.image,
                    size: 40,
                  ),
                ),
              );
            },
            errorWidget: (___, __, _) {
             // MyPrint.printOnConsole("Error Builder Called with imageUrl:${widget.imageUrl}");
              //updateProfilePictureAndNameInFeed();

              return Container(
                color: Colors.grey[200],
                child: Icon(
                  Icons.image_outlined,
                  color: Colors.grey[400],
                  size: 20,
                ),
              );
            },
          ) : Container(
            color: Colors.grey[200],
            child: Icon(
              Icons.image_outlined,
              color: Colors.grey[400],
              size: 20,
            ),
          ),
        ),
      ),
    );
  }
}


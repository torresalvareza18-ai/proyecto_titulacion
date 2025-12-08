import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class AmplifyVideoPlayer extends StatefulWidget {
  final String storageKey;

  const AmplifyVideoPlayer({super.key, required this.storageKey});

  @override
  State<AmplifyVideoPlayer> createState() => _AmplifyVideoPlayerState();
}

class _AmplifyVideoPlayerState extends State<AmplifyVideoPlayer> {
  VideoPlayerController? _videoController;
  ChewieController? _chewieController;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    try {
      final result = await Amplify.Storage.getUrl(
        key: 'public/${widget.storageKey}',
        options: const StorageGetUrlOptions(
          //accessLevel: StorageAccessLevel.guest,
          pluginOptions: S3GetUrlPluginOptions(
            validateObjectExistence: true,
            expiresIn: Duration(days: 1),
          ),
        ),
      ).result;
      
      final url = result.url;

      // 2. Configurar el controlador de video base
      _videoController = VideoPlayerController.networkUrl(url);
      await _videoController!.initialize();

      // 3. Configurar Chewie (la interfaz bonita con play/pause)
      _chewieController = ChewieController(
        videoPlayerController: _videoController!,
        aspectRatio: _videoController!.value.aspectRatio,
        autoPlay: false, // Importante: false para no volver loca la lista
        looping: false,
        errorBuilder: (context, errorMessage) {
          return Center(
            child: Text(
              errorMessage,
              style: const TextStyle(color: Colors.white),
            ),
          );
        },
      );

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Error al cargar video: $e';
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    // Importante: Liberar recursos para evitar fugas de memoria
    _videoController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const SizedBox(
        height: 200,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (_errorMessage != null) {
      return SizedBox(
        height: 200,
        child: Center(child: Icon(Icons.broken_image, color: Colors.grey)),
      );
    }

    return AspectRatio(
      aspectRatio: _videoController!.value.aspectRatio,
      child: Chewie(controller: _chewieController!),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';

class StorageImage extends StatefulWidget {
  final String imageKey;
  // CAMBIO 1: Ahora son opcionales (nullable)
  final double? width;
  final double? height;
  // CAMBIO 2: Tú controlas el ajuste
  final BoxFit fit;

  const StorageImage({
    super.key,
    required this.imageKey,
    this.width, // Si no lo pones, usa todo el ancho
    this.height, // Si no lo pones, usa todo el alto
    this.fit = BoxFit.cover, // Por defecto recorta para llenar
  });

  @override
  State<StorageImage> createState() => _StorageImageState();
}

class _StorageImageState extends State<StorageImage> with AutomaticKeepAliveClientMixin {
  String? _downloadUrl;
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _getUrl();
  }

  @override
  bool get wantKeepAlive => true;

  Future<void> _getUrl() async {
    print(widget.key);
    try {
      final result = await Amplify.Storage.getUrl(
        key: widget.imageKey,
        options: const StorageGetUrlOptions(
          accessLevel: StorageAccessLevel.guest,
          pluginOptions: S3GetUrlPluginOptions(
            validateObjectExistence: true,
            expiresIn: Duration(days: 1),
          ),
        ),
      ).result;

      print('El print es ${result}');

      if (mounted) {
        setState(() {
          _downloadUrl = result.url.toString();
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error obteniendo URL de imagen: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
          _hasError = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Widget placeholder mientras carga o si hay error
    Widget placeholder() => Container(
          width: widget.width,
          height: widget.height,
          color: Colors.grey[200],
          child: _hasError
              ? const Icon(Icons.error, color: Colors.red)
              : const Center(child: CircularProgressIndicator(strokeWidth: 2)),
        );

    if (_isLoading || _hasError || _downloadUrl == null) {
      return placeholder();
    }

    // CAMBIO 3: Lógica de caché inteligente
    // Si nos dieron un ancho específico, usamos el caché para optimizar el scroll.
    // Si NO nos dieron ancho (quieren tamaño completo), NO usamos caché para máxima calidad.
    final int? cacheWidth =
        widget.width != null ? (widget.width! * 2).toInt() : null;

    return Image.network(
      _downloadUrl!,
      width: widget.width,   // Puede ser null
      height: widget.height, // Puede ser null
      fit: widget.fit,       // El que tú elijas
      cacheWidth: cacheWidth, // Calidad dinámica
      
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return placeholder();
      },
       errorBuilder: (context, error, stackTrace) => placeholder(),
    );
  }
}
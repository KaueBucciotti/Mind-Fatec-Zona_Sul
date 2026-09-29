import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

/// -----------------------------------------------------------------------
/// AvatarCircle
/// -----------------------------------------------------------------------
/// Círculo colorido com as iniciais do nome, usado como avatar sempre
/// que o usuário/psicólogo não tem foto de perfil cadastrada.
///
/// A cor é escolhida de forma determinística a partir do [seed] (ex: o id
/// do psicólogo), garantindo que o mesmo profissional sempre tenha a
/// mesma cor de avatar em todas as telas.
/// -----------------------------------------------------------------------
class AvatarCircle extends StatelessWidget {
  final String iniciais;
  final String seed;
  final double size;

  const AvatarCircle({
    super.key,
    required this.iniciais,
    required this.seed,
    this.size = 48,
  });

  Color get _corDeFundo {
    final indice = seed.codeUnits.fold<int>(0, (soma, c) => soma + c) %
        AppColors.avatarPalette.length;
    return AppColors.avatarPalette[indice];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: _corDeFundo.withValues(alpha: 0.18),
        shape: BoxShape.circle,
      ),
      child: Text(
        iniciais,
        style: TextStyle(
          color: _corDeFundo,
          fontWeight: FontWeight.w700,
          fontSize: size * 0.36,
        ),
      ),
    );
  }
}

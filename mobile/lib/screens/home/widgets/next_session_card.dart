import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../models/appointment_model.dart';
import '../../../widgets/avatar_circle.dart';

/// -----------------------------------------------------------------------
/// NextSessionCard
/// -----------------------------------------------------------------------
/// Card laranja em destaque na Home mostrando a próxima sessão agendada,
/// com contagem regressiva e botão para entrar na sala de atendimento.
/// -----------------------------------------------------------------------
class NextSessionCard extends StatelessWidget {
  final AppointmentModel consulta;
  final VoidCallback onEntrarNaSala;

  const NextSessionCard({
    super.key,
    required this.consulta,
    required this.onEntrarNaSala,
  });

  @override
  Widget build(BuildContext context) {
    final horario = TimeOfDay.fromDateTime(consulta.dataHora).format(context);

    return Container(
      padding: const EdgeInsets.all(AppConstants.spaceM),
      decoration: BoxDecoration(
        color: AppColors.accent,
        borderRadius: BorderRadius.circular(AppConstants.radiusM),
      ),
      child: Row(
        children: [
          // Usa a cor de fundo branca semitransparente para contrastar com o laranja.
          Container(
            padding: const EdgeInsets.all(2),
            decoration: const BoxDecoration(color: Colors.white24, shape: BoxShape.circle),
            child: AvatarCircle(iniciais: consulta.psicologo.iniciais, seed: consulta.psicologo.id),
          ),
          const SizedBox(width: AppConstants.spaceM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  consulta.psicologo.nome,
                  style: AppTextStyles.heading3.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 2),
                Text(
                  '${consulta.isHoje ? "Hoje" : ""} · $horario · Online'.trim(),
                  style: AppTextStyles.caption.copyWith(color: Colors.white.withValues(alpha: 0.9)),
                ),
                if (consulta.tempoRestanteFormatado != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Em ${consulta.tempoRestanteFormatado}',
                    style: AppTextStyles.caption.copyWith(color: Colors.white70),
                  ),
                ],
              ],
            ),
          ),
          ElevatedButton(
            onPressed: onEntrarNaSala,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppColors.accent,
              minimumSize: const Size(0, 36),
              padding: const EdgeInsets.symmetric(horizontal: 14),
            ),
            child: const Text('Entrar na sala', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}

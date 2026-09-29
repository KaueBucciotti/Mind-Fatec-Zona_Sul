import 'package:flutter/material.dart';
import '../core/constants/app_constants.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';
import '../models/psychologist_model.dart';
import 'avatar_circle.dart';

/// -----------------------------------------------------------------------
/// PsychologistCard
/// -----------------------------------------------------------------------
/// Card usado nas seções "Recomendados" (Home) e na lista de resultados
/// da tela de Busca. Exibe avatar, nome, especialidades, avaliação,
/// preço e um botão de ação (e, opcionalmente, WhatsApp).
///
/// O parâmetro [showWhatsApp] permite reutilizar o mesmo card tanto na
/// Home (sem botão de WhatsApp) quanto na tela de Busca (com o botão).
/// -----------------------------------------------------------------------
class PsychologistCard extends StatelessWidget {
  final PsychologistModel psicologo;
  final VoidCallback? onVerPerfil;
  final VoidCallback? onWhatsApp;
  final bool showWhatsApp;

  const PsychologistCard({
    super.key,
    required this.psicologo,
    this.onVerPerfil,
    this.onWhatsApp,
    this.showWhatsApp = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spaceM),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppConstants.radiusM),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AvatarCircle(iniciais: psicologo.iniciais, seed: psicologo.id),
              const SizedBox(width: AppConstants.spaceM),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(psicologo.nome, style: AppTextStyles.heading3),
                    const SizedBox(height: 2),
                    Text(
                      psicologo.especialidades.join(' • '),
                      style: AppTextStyles.bodySecondary,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.star_rounded, color: AppColors.star, size: 16),
                        const SizedBox(width: 2),
                        Text('${psicologo.avaliacao}', style: AppTextStyles.caption.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w700)),
                        const SizedBox(width: 4),
                        Text('(${psicologo.totalAvaliacoes})', style: AppTextStyles.caption),
                        const SizedBox(width: 10),
                        Text('${psicologo.anosExperiencia} anos', style: AppTextStyles.caption),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(psicologo.precoFormatado, style: AppTextStyles.heading3),
                  Text('/sessão', style: AppTextStyles.caption),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spaceS),
          // Tags de abordagem terapêutica (ex: TCC, ACT)
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: psicologo.abordagens
                .map((a) => _Tag(label: a.label))
                .toList(),
          ),
          const SizedBox(height: AppConstants.spaceM),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 40,
                  child: ElevatedButton(
                    onPressed: onVerPerfil,
                    style: ElevatedButton.styleFrom(padding: EdgeInsets.zero),
                    child: const Text('Ver'),
                  ),
                ),
              ),
              if (showWhatsApp) ...[
                const SizedBox(width: AppConstants.spaceS),
                Expanded(
                  child: SizedBox(
                    height: 40,
                    child: OutlinedButton.icon(
                      onPressed: onWhatsApp,
                      icon: const Icon(Icons.chat_bubble_rounded, size: 16, color: AppColors.success),
                      label: const Text('WhatsApp'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.success,
                        side: const BorderSide(color: AppColors.success),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

/// Tag pequena usada para exibir abordagens terapêuticas (ex: "TCC").
class _Tag extends StatelessWidget {
  final String label;
  const _Tag({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.backgroundMint,
        borderRadius: BorderRadius.circular(AppConstants.radiusPill),
      ),
      child: Text(
        label,
        style: AppTextStyles.caption.copyWith(color: AppColors.primary, fontWeight: FontWeight.w600),
      ),
    );
  }
}

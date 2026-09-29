import 'psychologist_model.dart';

/// Status possíveis de uma consulta.
enum AppointmentStatus { agendada, concluida, cancelada }

/// -----------------------------------------------------------------------
/// AppointmentModel
/// -----------------------------------------------------------------------
/// Representa uma consulta/sessão marcada entre paciente e psicólogo.
/// Usada nas telas de "Próxima sessão", "Minhas consultas" e histórico.
/// -----------------------------------------------------------------------
class AppointmentModel {
  final String id;
  final PsychologistModel psicologo;
  final DateTime dataHora;
  final Modalidade modalidade;
  final AppointmentStatus status;

  const AppointmentModel({
    required this.id,
    required this.psicologo,
    required this.dataHora,
    this.modalidade = Modalidade.online,
    this.status = AppointmentStatus.agendada,
  });

  /// Indica se a consulta é hoje — usado para destacar o card
  /// "Próxima sessão" e habilitar o botão "Entrar na sala".
  bool get isHoje {
    final agora = DateTime.now();
    return dataHora.year == agora.year &&
        dataHora.month == agora.month &&
        dataHora.day == agora.day;
  }

  /// Tempo restante até a consulta, formatado de forma amigável
  /// (ex: "2h 15min"). Retorna null se a consulta já passou.
  String? get tempoRestanteFormatado {
    final diferenca = dataHora.difference(DateTime.now());
    if (diferenca.isNegative) return null;
    final horas = diferenca.inHours;
    final minutos = diferenca.inMinutes.remainder(60);
    if (horas > 0) return '${horas}h ${minutos}min';
    return '${minutos}min';
  }

  static List<AppointmentModel> mockList() {
    final psicologos = PsychologistModel.mockList();
    final hoje = DateTime.now();
    return [
      AppointmentModel(
        id: 'a1',
        psicologo: psicologos[0],
        dataHora: DateTime(hoje.year, hoje.month, hoje.day, 15, 0),
      ),
      AppointmentModel(
        id: 'a2',
        psicologo: psicologos[1],
        dataHora: hoje.add(const Duration(days: 2)).copyWith(hour: 10, minute: 0),
      ),
      AppointmentModel(
        id: 'a3',
        psicologo: psicologos[0],
        dataHora: hoje.add(const Duration(days: 6)).copyWith(hour: 15, minute: 0),
      ),
    ];
  }
}

/// Pequena extensão utilitária para "copiar" um DateTime alterando
/// apenas hora/minuto — usada acima para gerar dados fictícios.
extension DateTimeCopyWith on DateTime {
  DateTime copyWith({int? hour, int? minute}) {
    return DateTime(year, month, day, hour ?? this.hour, minute ?? this.minute);
  }
}

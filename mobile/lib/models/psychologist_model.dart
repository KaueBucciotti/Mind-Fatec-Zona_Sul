/// -----------------------------------------------------------------------
/// Abordagem terapêutica do psicólogo (usada em tags e filtros).
/// -----------------------------------------------------------------------
enum Abordagem {
  tcc('TCC'),
  psicanalise('Psicanálise'),
  humanista('Humanista'),
  emdr('EMDR'),
  gestalt('Gestalt'),
  act('ACT'),
  sistemica('Sistêmica'),
  transpessoal('Transpessoal');

  final String label;
  const Abordagem(this.label);
}

/// Modalidade de atendimento oferecida.
enum Modalidade { online, presencial }

/// -----------------------------------------------------------------------
/// PsychologistModel
/// -----------------------------------------------------------------------
/// Representa um profissional listado no app (busca, recomendados, etc).
/// -----------------------------------------------------------------------
class PsychologistModel {
  final String id;
  final String nome;
  final String? fotoUrl;
  final List<String> especialidades; // Ex: ["Ansiedade", "Depressão"]
  final List<Abordagem> abordagens;
  final double avaliacao; // Ex: 4.9
  final int totalAvaliacoes; // Ex: 124
  final int anosExperiencia;
  final double precoSessao;
  final List<Modalidade> modalidades;
  final String? crp; // Registro profissional (CRP)

  const PsychologistModel({
    required this.id,
    required this.nome,
    this.fotoUrl,
    required this.especialidades,
    required this.abordagens,
    required this.avaliacao,
    required this.totalAvaliacoes,
    required this.anosExperiencia,
    required this.precoSessao,
    this.modalidades = const [Modalidade.online],
    this.crp,
  });

  String get inicial => nome.isNotEmpty ? nome[0].toUpperCase() : '?';

  /// Retorna as iniciais (ex: "Laura Almeida" -> "LA"), usadas como
  /// avatar padrão quando o profissional não possui foto cadastrada.
  String get iniciais {
    final partes = nome.trim().split(RegExp(r'\s+'));
    if (partes.length == 1) return partes.first.substring(0, 1).toUpperCase();
    return (partes.first[0] + partes.last[0]).toUpperCase();
  }

  String get precoFormatado => 'R\$ ${precoSessao.toStringAsFixed(0)}';

  /// Dados fictícios para prototipação das telas de listagem/busca.
  static List<PsychologistModel> mockList() {
    return const [
      PsychologistModel(
        id: 'p1',
        nome: 'Laura Almeida',
        especialidades: ['Ansiedade', 'Depressão'],
        abordagens: [Abordagem.tcc, Abordagem.act],
        avaliacao: 4.9,
        totalAvaliacoes: 124,
        anosExperiencia: 8,
        precoSessao: 180,
      ),
      PsychologistModel(
        id: 'p2',
        nome: 'Carlos Melo',
        especialidades: ['Autoconhecimento', 'Luto'],
        abordagens: [Abordagem.humanista, Abordagem.gestalt],
        avaliacao: 4.8,
        totalAvaliacoes: 89,
        anosExperiencia: 12,
        precoSessao: 160,
      ),
      PsychologistModel(
        id: 'p3',
        nome: 'Fernanda Costa',
        especialidades: ['Trauma', 'TEPT'],
        abordagens: [Abordagem.emdr, Abordagem.psicanalise],
        avaliacao: 4.7,
        totalAvaliacoes: 203,
        anosExperiencia: 15,
        precoSessao: 220,
      ),
      PsychologistModel(
        id: 'p4',
        nome: 'Rafael Santos',
        especialidades: ['Burnout', 'Mindfulness'],
        abordagens: [Abordagem.tcc, Abordagem.act],
        avaliacao: 4.9,
        totalAvaliacoes: 156,
        anosExperiencia: 10,
        precoSessao: 190,
        modalidades: [Modalidade.online, Modalidade.presencial],
      ),
    ];
  }
}

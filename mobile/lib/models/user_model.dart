/// -----------------------------------------------------------------------
/// Tipo de conta do usuário.
/// Reflete a escolha feita na tela de cadastro ("Paciente" ou "Psicólogo").
/// -----------------------------------------------------------------------
enum UserRole { paciente, psicologo }

/// -----------------------------------------------------------------------
/// UserModel
/// -----------------------------------------------------------------------
/// Representa o usuário autenticado no app (paciente ou psicólogo).
///
/// Mantemos os modelos como classes imutáveis (todos os campos `final`)
/// e com `copyWith` para facilitar atualizações parciais sem mutar o
/// objeto original — uma boa prática em apps que usam gerenciamento de
/// estado (Provider, Riverpod, Bloc, etc).
/// -----------------------------------------------------------------------
class UserModel {
  final String id;
  final String nome;
  final String email;
  final String? telefone;
  final UserRole role;
  final String plano; // Ex: "Plano Básico"
  final String? fotoUrl;

  // Estatísticas exibidas no perfil (sessões, meses, psicólogos)
  final int totalSessoes;
  final int mesesDeJornada;
  final int totalPsicologos;

  const UserModel({
    required this.id,
    required this.nome,
    required this.email,
    this.telefone,
    required this.role,
    this.plano = 'Plano Básico',
    this.fotoUrl,
    this.totalSessoes = 0,
    this.mesesDeJornada = 0,
    this.totalPsicologos = 0,
  });

  /// Retorna a primeira letra do nome, usada como avatar quando
  /// não há foto de perfil cadastrada.
  String get inicial => nome.isNotEmpty ? nome[0].toUpperCase() : '?';

  UserModel copyWith({
    String? id,
    String? nome,
    String? email,
    String? telefone,
    UserRole? role,
    String? plano,
    String? fotoUrl,
    int? totalSessoes,
    int? mesesDeJornada,
    int? totalPsicologos,
  }) {
    return UserModel(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      email: email ?? this.email,
      telefone: telefone ?? this.telefone,
      role: role ?? this.role,
      plano: plano ?? this.plano,
      fotoUrl: fotoUrl ?? this.fotoUrl,
      totalSessoes: totalSessoes ?? this.totalSessoes,
      mesesDeJornada: mesesDeJornada ?? this.mesesDeJornada,
      totalPsicologos: totalPsicologos ?? this.totalPsicologos,
    );
  }

  /// Fábrica de dados fictícios para prototipação/telas de exemplo.
  /// Em produção, isso seria substituído por dados vindos de uma API.
  factory UserModel.mock() {
    return const UserModel(
      id: 'u1',
      nome: 'João Silva',
      email: 'joao@email.com',
      role: UserRole.paciente,
      plano: 'Plano Básico',
      totalSessoes: 12,
      mesesDeJornada: 4,
      totalPsicologos: 2,
    );
  }
}

enum CompetencySkill {
  DataManagement,
  Surveillance,
  DataAnalysis,
}

extension CompetencySkillExtension on CompetencySkill {
  String toMap() {
    return this
        .toString()
        .split('.')
        .last;
  }

  static CompetencySkill fromString(String skill) {
    switch (skill) {
      case 'DataManagement':
        return CompetencySkill.DataManagement;
      case 'Surveillance':
        return CompetencySkill.Surveillance;
      case 'DataAnalysis':
        return CompetencySkill.DataAnalysis;
      default:
        throw ArgumentError('Unknown CompetencySkill: $skill');
    }
  }
}

enum WorkAssignment {
  sample1,
  sample2
}

enum Cadre {
  cadre1,
  cadre2
}

enum Suffix {
  senior,
  junior,
  ii,
  iii,
  iv,
  v,
  vi,
  vii,
  viii,
  ix,
  x,
  xi,
  xii,
  xiii,
  xiv,
  xv
}

enum GenderPronoun {
  he,
  she,
  they,
  zhe
}

enum CoreSkill {
  coreSkill1,
  coreSkill2
}

enum ProfessionalLicenses {
  professionalLicenses1,
  professionalLicenses2
}

enum InstitutionType {
  hospital,
  socialHygieneClinic,
  healthCenter
}
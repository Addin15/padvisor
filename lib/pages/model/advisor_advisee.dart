class AdvisorAdvisee {
  String? id;
  String? name;
  List<Advisee>? advisees;

  AdvisorAdvisee(this.id, this.name, {this.advisees = const []});

  void setAdvisees(List<Advisee>? advisees) {
    this.advisees = advisees;
  }
}

class Advisee {
  String? id;
  String? name;

  Advisee(this.id, this.name);
}

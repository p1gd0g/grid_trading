enum Exchange {
  unknown,
  sh,
  sz,
  us,
  hk,
  crypto;

  bool get isAShare => this == .sh || this == .sz;
}

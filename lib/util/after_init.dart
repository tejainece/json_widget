mixin AfterInit {
  bool _onlyOnce = false;

  void didChangeDependencies() {
    triggerAfterInit();
  }

  void triggerAfterInit() {
    if (_onlyOnce) return;

    afterInit();
    _onlyOnce = true;
  }

  void afterInit();
}

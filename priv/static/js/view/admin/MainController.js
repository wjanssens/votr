Ext.define('Votr.view.admin.MainController', {
    extend: 'Ext.app.ViewController',
    alias: 'controller.admin.main',

    routes : {
        'dashboard': 'onDashboard',
        'profile': 'onProfile',
        'wards': 'onWards',
        'wards/:id': 'onWard',
        'wards/:id/ballots': 'onBallots',
        'wards/:id/voters': 'onVoters',
        'ballots/:id': 'onBallot',
        'ballots/:id/candidates': 'onCandidates',
        'ballots/:id/results': 'onResults',
        'ballots/:id/log': 'onLog',
        'voters/:id': 'onVoter',
        'candidates/:id': 'onCandidate'
    },

    onHome() {
        this.redirectTo('#dashboard');
    },

    onProfileEdit() {
        this.redirectTo('#profile');
    },

    onDashboard() {
        this.setActiveItem(0)
    },

    onWards() {
        this.setActiveItem(1, 'root');
    },

    onWard(id) {
        this.setActiveItem(1, id);
    },

    onBallots(id) {
        this.setActiveItem(2, id);
    },

    onBallot(id) {
        this.setActiveItem(2, id);
    },

    onVoters(id) {
        this.setActiveItem(3, id);
    },

    onVoter(id) {
        this.setActiveItem(3, id);
    },

    onCandidates(id) {
        this.setActiveItem(4, id);
    },

    onCandidate(id) {
        this.setActiveItem(4, id);
    },

    onResults(id) {
        this.setActiveItem(5, id);
    },

    onLog(id) {
        this.setActiveItem(7, id); // TODO
    },

    onProfile() {
        this.setActiveItem(7, id);
    },

    setActiveItem(index, id) {
        const cards = this.getView().setActiveItem(1).down('#cards');
        cards.setActiveItem(index);
        cards.getActiveItem().getViewModel().set("id", id);
        cards.getActiveItem().getViewModel().notify();
    },

});

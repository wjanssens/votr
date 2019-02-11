Ext.define('Votr.view.admin.MainController', {
    extend: 'Ext.app.ViewController',
    alias: 'controller.admin.main',

    routes : {
        'profile': 'onProfile',
        'wards': 'onWards',
        'wards/:id': 'onWard',
        'wards/:id/ballots': 'onBallots',
        'wards/:id/voters': 'onVoters',
        'ballots/:id': 'onBallot',
        'ballots/:id/candidates': 'onCandidates',
        'ballots/:id/results': 'onResults',
        'ballots/:id/log': 'onLog',
        'voters:/id': 'onVoter',
        'candidates/:id': 'onCandidate'
    },

    onHome() {
        this.redirectTo('#wards');
    },

    onProfileEdit() {
        this.redirectTo('#profile');
    },

    onWards() {
        this.setActiveItem(0, 'root');
    },

    onWard(id) {
        this.setActiveItem(0, id);
    },

    onBallots(id) {
        this.setActiveItem(1, id);
    },

    onBallot(id) {
        this.setActiveItem(1, id);
    },

    onVoters(id) {
        this.setActiveItem(2, id);
    },

    onVoter(id) {
        this.setActiveItem(2, id);
    },

    onCandidates(id) {
        this.setActiveItem(3, id);
    },

    onCandidate(id) {
        this.setActiveItem(3, id);
    },

    onResults(id) {
        this.setActiveItem(4, id);
    },

    onLog(id) {
        this.setActiveItem(5, id);
    },

    onProfile() {
        this.setActiveItem(6, id);
    },

    setActiveItem(index, id) {
        const cards = this.getView().setActiveItem(1).down('#cards');
        cards.setActiveItem(index);
        cards.getActiveItem().getViewModel().set("id", id);
        cards.getActiveItem().getViewModel().notify();
    },

});
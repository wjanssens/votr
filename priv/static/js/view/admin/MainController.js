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
        'candidates/:id': 'onCandidate',
    },

    onHome() {
        this.redirectTo('#wards');
    },

    onWards() {
        this.getView().setActiveItem(1).down('#elector_cards').setActiveItem(0);
    },

    onWard() {
        this.getView().setActiveItem(1).down('#elector_cards').setActiveItem(0);
    },

    onBallots() {
        this.getView().setActiveItem(1).down('#elector_cards').setActiveItem(1);
    },

    onBallot() {
        this.getView().setActiveItem(1).down('#elector_cards').setActiveItem(1);
    },

    onVoters() {
        this.getView().setActiveItem(1).down('#elector_cards').setActiveItem(2);
    },

    onVoter() {
        this.getView().setActiveItem(1).down('#elector_cards').setActiveItem(2);
    },

    onCandidates() {
        this.getView().setActiveItem(1).down('#elector_cards').setActiveItem(3);
    },

    onCandidate() {
        this.getView().setActiveItem(1).down('#elector_cards').setActiveItem(3);
    },

    onResults() {
        this.getView().setActiveItem(1).down('#elector_cards').setActiveItem(4);
    },

    onLog() {
        this.getView().setActiveItem(1).down('#elector_cards').setActiveItem(5);
    }

});
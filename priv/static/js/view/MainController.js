Ext.define('Votr.view.MainController', {
    extend: 'Ext.app.ViewController',
    alias: 'controller.main',

    routes : {
        // login
        'login': 'onLogin',

        // voters
        'vote': 'onVote',

        // officials
        'profile': 'onProfile',
        'wards': 'onWards',
        'wards/:id': 'onWard',
        'wards/:id/ballots': 'onBallots',
        'wards/:id/voters': 'onVoters',
        'ballots/:id': 'onBallot',
        'ballots/:id/candidates': 'onCandidates',
        'ballots/:id/results': 'onResults',
        'voters:/id': 'onVoter',
        'candidates/:id': 'onCandidate',
    },

    // login

    onLogin() {
        this.getView().setActiveItem(0);
    },

    // voters

    onVote() {
        this.getView().setActiveItem(2);
    },

    // officials

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
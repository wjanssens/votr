Ext.define('Votr.view.public.MainController', {
    extend: 'Ext.app.ViewController',
    alias: 'controller.public.main',

    routes: {
        'ballots': 'onBallots',
        'ballots/:id': 'onBallot'
    },

    onBallots() {
        this.getView().down('#cards').setActiveItem(0);
    },

    onBallot() {
        this.getView().down('#cards').setActiveItem(1);
    },

    onItemTap: function() {
        this.redirectTo('#ballots/1')
    }


});
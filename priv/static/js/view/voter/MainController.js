Ext.define('Votr.view.voter.MainController', {
    extend: 'Ext.app.ViewController',
    alias: 'controller.voter.main',

    routes : {
        'ballots': 'onBallots'
    }

});
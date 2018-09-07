Ext.application({
    name: 'Votr',
    appFolder: '../js',
    controllers: ['Voter'],
    requires: [
        'Votr.view.voter.Main'
    ],
    defaultToken: 'ballots',

    launch: function () {
        Ext.Viewport.add(Ext.create('Votr.view.voter.Main'))
    }
});

Ext.onReady(function () {
    Ext.get(window.document).on('contextmenu', function (e) {
        e.preventDefault();
        return false;
    });
});
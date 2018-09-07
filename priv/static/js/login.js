Ext.application({
    name: 'Votr',
    appFolder: 'js',
    controllers: ['Login'],
    requires: [
        'Votr.view.login.Main'
    ],
    defaultToken: 'ballot',

    launch: function () {
        Ext.Viewport.add(Ext.create('Votr.view.login.Main'))
    }
});

Ext.onReady(function () {
    Ext.get(window.document).on('contextmenu', function (e) {
        e.preventDefault();
        return false;
    });
});
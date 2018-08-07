Ext.application({
    name: 'Votr',
    appFolder: 'js',
    controllers: ['Main','Wards'],
    requires: [
        'Votr.view.Main'
    ],
    launch: function () {
        Ext.Viewport.add(Ext.create('Votr.view.Main'))
    }
});

Ext.onReady(function () {
    Ext.get(window.document).on('contextmenu', function (e) {
        e.preventDefault();
        return false;
    });
});
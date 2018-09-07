Ext.application({
    name: 'Votr',
    appFolder: '../js',
    controllers: ['Admin'],
    requires: [
        'Votr.view.admin.Main'
    ],
    defaultToken: 'wards',

    launch: function () {
        Ext.Viewport.add(Ext.create('Votr.view.admin.Main'))
    }
});

Ext.onReady(function () {
    Ext.get(window.document).on('contextmenu', function (e) {
        e.preventDefault();
        return false;
    });
});
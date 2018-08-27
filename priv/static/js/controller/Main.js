Ext.define('Votr.controller.Main', {
    extend: 'Ext.app.Controller',

    requires: [
        "Votr.view.MainController"
    ],

    views: [
        'Main', 'login.Login', 'admin.Main'
    ]

})

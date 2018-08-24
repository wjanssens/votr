Ext.define('Votr.controller.Main', {
    extend: 'Ext.app.Controller',

    requires: [
        "Votr.view.MainController"
    ],

    views: [
        'Login', 'Main', 'Admin', 'Elector', 'Vote'
    ]

})

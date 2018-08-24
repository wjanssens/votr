Ext.define('Votr.controller.Admin', {
    extend: 'Ext.app.Controller',
    views: [
        'Users', 'User'
    ],
    models: [
        'User'
    ],
    stores: [
        'Users'
    ]
})

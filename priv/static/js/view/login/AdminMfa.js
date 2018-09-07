Ext.define('Votr.view.login.AdminMfa', {
    extend: 'Ext.form.Panel',
    alias: 'widget.login.adminmfa',
    title: 'Two Step Verification',
    xtype: 'formpanel',
    requires: [
        'Votr.view.login.LoginController'
    ],
    controller: 'login.login',
    items: [{
        xtype: 'textfield',
        name: 'code',
        label: 'Code'
    }, {
        xtype: 'toolbar',
        docked: 'bottom',
        items: ['->', {
            xtype: 'button',
            text: 'Next',
            handler: 'onAdminMfa'
        }]
    }]
});
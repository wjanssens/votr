Ext.define('Votr.view.login.AdminMfa', {
    extend: 'Ext.form.Panel',
    alias: 'widget.login.adminmfa',
    title: 'Two Step Verification'.translate(),
    requires: [
        'Votr.view.login.LoginController'
    ],
    controller: 'login.login',
    items: [{
        xtype: 'textfield',
        name: 'code',
        label: 'Code'
    },
    {
        flex: 1
    },
    {
        itemId: 'message',
        html: 'Enter the code from your two-factor authentication app, or alternatively, use one of your backup codes.'.translate()
    },
    {
        xtype: 'toolbar',
        docked: 'bottom',
        items: ['->', {
            xtype: 'button',
            text: 'Verify',
            handler: 'onAdminMfa'
        }]
    }]
});
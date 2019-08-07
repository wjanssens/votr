Ext.define('Votr.view.index.Main', {
    extend: 'Ext.Panel',
    alias: 'widget.index.main',
    padding: 0,
    layout: 'hbox',
    scrollable: 'vertical',
    requires: [
        "Votr.view.index.MainController"
    ],
    controller: 'index.main',
    items: [
        {
            xtype: 'toolbar',
            itemId: 'toolbar',
            docked: 'top',
            title: 'Votr',
            items: [
                '->',
                {
                    xtype: 'button',
                    text: 'Sign Up',
                    handler: 'onSignUp'
                },
                {
                    xtype: 'button',
                    text: 'Sign In',
                    handler: 'onSignIn'
                }
            ]
        }, {
            xtype: 'panel',
            flex: 1,
            layout: 'vbox',
            padding: 0,
            items: [
                {xtype: 'index.hero'},
                {xtype: 'index.testimonials'},
                {xtype: 'index.features'},
                {xtype: 'index.organizations'},
                {xtype: 'index.footer'}
            ]
        }
    ]
});
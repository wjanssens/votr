Ext.define('Votr.view.login.Main', {
    extend: 'Ext.Container',
    alias: 'widget.login',
    layout: 'hbox',
    requires: [
        "Votr.view.login.MainController"
    ],
    controller: 'login.main',
    padding: 0,
    style: 'background: #f5f5fa;',
    items: [{
        xtype: 'container',
        flex: 1,
    }, {
        xtype: 'container',
        padding: 0,
        layout: 'vbox',
        plugins: 'responsive',
        responsiveConfig: {
            'width < 512': {
                width: '100%'
            },
            'width >= 512': {
                width: 512
            },
        },
        items: [
            {
                xtype: 'container',
                flex: 1
            },
            {
                xtype: 'panel',
                itemId: 'login_cards',
                border: 1,
                height: 320,
                layout: 'card',
                shadow: true,
                responsiveConfig: {
                    'height < 384': {
                        height: '100%'
                    },
                    'height >= 384': {
                        height: 384
                    }
                }, items: [
                    {xtype: 'login.voterballot'},
                    {xtype: 'login.votercredentials'},
                    {xtype: 'login.adminlogin'},
                    {xtype: 'login.adminmfa'},
                    {xtype: 'login.adminregister'},
                    {xtype: 'login.adminforgotpassword'},
                    {xtype: 'login.adminresetpassword'}
                ]
            },
            {
                xtype: 'container',
                flex: 1
            },
        ]
    }, {
        xtype: 'container',
        flex: 1,
    }]
});
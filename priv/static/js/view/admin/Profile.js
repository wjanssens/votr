Ext.define('Votr.view.admin.Profile', {
    extend: 'Ext.panel.Panel',
    alias: 'widget.admin.profile',
    layout: 'vbox',
    items: [
        {
            xtype: 'formpanel',
            items: [
                {
                    xtype: 'passwordfield',
                    name: 'current_password',
                    label: 'Current Password'
                },
                {
                    xtype: 'passwordfield',
                    name: 'password',
                    label: 'New Password'
                },
                {
                    xtype: 'passwordfield',
                    name: 'retype_password',
                    label: 'Retype Password'
                },
                {
                    xtype: 'emailfield',
                    readOnly: true,
                    name: 'email',
                    label: 'Email',
                    value: 'lisa@example.com',
                }
            ]
        },
        {
            xtype: 'toolbar',
            itemId: 'toolbar',
            docked: 'bottom',
            items: ['->', {
                xtype: 'button',
                text: 'Enable Two Factor Auth',
                ui: 'forward',
                handler: 'onDelete'
            }, '->', {
                xtype: 'button',
                text: 'Save',
                ui: 'confirm',
                handler: 'onSave'
            }
        ]}
    ]
});
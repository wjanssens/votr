Ext.define('Votr.view.admin.Profile', {
    extend: 'Ext.panel.Panel',
    alias: 'widget.admin.profile',
    layout: 'vbox',
    items: [
        {
            xtype: 'formpanel',
            items: [{
                xtype: 'textfield',
                name: 'username',
                label: 'Username'
            }, {
                xtype: 'passwordfield',
                name: 'password',
                label: 'Password'
            }, {
                xtype: 'textfield',
                name: 'name',
                label: 'Name'
            }, {
                xtype: 'panel',
                layout: 'hbox',
                padding: 0,
                items: [
                    {
                        xtype: 'emailfield',
                        name: 'email',
                        label: 'Email',
                        flex: 1
                    },
                    {
                        xtype: 'selectfield',
                        name: 'email_label',
                        label: 'Label',
                        width: 128,
                        queryMode: 'local',
                        options: [
                            {value: 'home', text: 'Home'},
                            {value: 'work', text: 'Work'},
                            {value: 'other', text: 'Other'}
                        ]
                    }
                ]
            }, {
                xtype: 'panel',
                layout: 'hbox',
                padding: 0,
                items: [
                    {
                        xtype: 'textfield',
                        name: 'phone',
                        label: 'Phone',
                        flex: 1
                    },
                    {
                        xtype: 'selectfield',
                        name: 'phone_label',
                        label: 'Label',
                        width: 128,
                        queryMode: 'local',
                        options: [
                            {value: 'mobile', text: 'Mobile'},
                            {value: 'iphone', text: 'iPhone'},
                            {value: 'home', text: 'Home'},
                            {value: 'work', text: 'Work'},
                            {value: 'main', text: 'Main'},
                            {value: 'home fax', text: 'Home Fax'},
                            {value: 'work fax', text: 'Work Fax'},
                            {value: 'other fax', text: 'Other Fax'},
                            {value: 'pager', text: 'Pager'},
                            {value: 'other', text: 'Other'}
                        ]
                    }
                ]
            }, {
                xtype: 'panel',
                layout: 'hbox',
                padding: 0,
                items: [
                    {
                        xtype: 'textfield',
                        name: 'challenge',
                        label: 'Challenge',
                        flex: 1
                    },
                    {
                        xtype: 'textfield',
                        name: 'response',
                        label: 'Response',
                        flex: 1
                    }
                ]
            }]
        }
    ]
});
Ext.define('Votr.view.Voter', {
    extend: 'Ext.panel.Panel',
    alias: 'widget.voter',
    layout: 'vbox',
    title: 'Voters',
    tools: [
        {
            iconCls: 'x-fa fa-plus',
            handler: function () {
            }
        }, {
            iconCls: 'x-fa fa-upload',
            handler: function () {
            }
        }, {
            iconCls: 'x-fa fa-filter',
            handler: function () {
            }
        }
    ],
    items: [
        {
            xtype: 'formpanel',
            items: [{
                xtype: 'textfield',
                name: 'ext_id',
                label: 'External ID'
            }, {
                xtype: 'textfield',
                name: 'email',
                label: 'Email',
            }, {
                xtype: 'textfield',
                name: 'phone',
                label: 'Phone',
            }, {
                xtype: 'datepicker',
                name: 'dob',
                label: 'Date of Birth',
            }, {
                xtype: 'textareafield',
                name: 'postal_address',
                label: 'Postal Address'
            }]
        }
    ]
});
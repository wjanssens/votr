Ext.define('Votr.view.admin.Voter', {
    extend: 'Ext.panel.Panel',
    alias: 'widget.admin.voter',
    layout: 'vbox',
    items: [
        {
            xtype: 'formpanel',
            items: [{
                xtype: 'textfield',
                name: 'name',
                label: 'Name',
                bind: '{voterList.selection.name}'
            }, {
                xtype: 'textfield',
                name: 'ext_id',
                label: 'External ID',
                bind: '{voterList.selection.ext_id}'
            }, {
                xtype: 'fieldset',
                title: 'Address Information',
                tooltip: 'used to deliver ballot information to voter',
                items: [
                    {
                        xtype: 'emailfield',
                        name: 'email',
                        label: 'Email',
                        bind: '{voterList.selection.email}'
                    }, {
                        xtype: 'textfield',
                        name: 'phone',
                        label: 'Mobile Phone (E.164)',
                        placeHolder: 'e.g. +1 415 555 2671 ; +44 20 7183 8750',
                        bind: '{voterList.selection.phone}'
                    }, {
                        xtype: 'textareafield',
                        name: 'postal address',
                        label: 'Postal Address',
                        maxRows: 5,
                        bind: '{voterList.selection.postal_address}'
                    }
                ]
            }, {
                xtype: 'fieldset',
                title: 'Identity',
                tooltip: 'used to confirm voter identity',
                items: [
                    {
                        xtype: 'textfield',
                        name: 'dob',
                        label: 'Date of Birth',
                        bind: '{voterList.selection.dob}'
                    }, {
                        xtype: 'textfield',
                        tooltip: 'Citizen Card, Passport Card, Voter Card, PAN card, Drivers License, Passport, Tax Number, etc...',
                        name: 'identity_card_number',
                        label: 'Identity Card Number',
                        bind: '{voterList.selection.identity_card}'
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
                    }
                ]
            }]
        }
    ]
});
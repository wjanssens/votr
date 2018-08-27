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
                label: 'Name'
            }, {
                xtype: 'textfield',
                name: 'ext_id',
                label: 'External ID'
            }, {
                xtype: 'fieldset',
                title: 'Address Information',
                tooltip: 'used to deliver ballot information to voter',
                items: [
                    {
                        xtype: 'emailfield',
                        name: 'email',
                        label: 'Email'
                    }, {
                        xtype: 'textfield',
                        name: 'phone',
                        label: 'Mobile Phone (E.164)',
                        placeHolder: 'e.g. +1 415 555 2671 ; +44 20 7183 8750'
                    }, {
                        xtype: 'textareafield',
                        name: 'postal address',
                        label: 'Postal Address',
                        maxRows: 5
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
                    }, {
                        xtype: 'textfield',
                        tooltip: 'Citizen Card, Passport Card, Voter Card, PAN card, Drivers License, Passport, Tax Number, etc...',
                        name: 'identity_card_number',
                        label: 'Identity Card Number',
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
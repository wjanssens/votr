Ext.define('Votr.view.admin.Voter', {
    extend: 'Ext.form.Panel',
    alias: 'widget.admin.voter',
    layout: 'vbox',
    bind: {
        disabled: '{!voterList.selection}'
    },
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
        xtype: 'numberfield',
        name: 'weight',
        label: 'Weight',
        bind: '{woterList.selection.weight}'
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
                tooltip: 'Citizen Card, Passport Card, Voter Card, PAN card, Drivers License, Passport, Tax Number, Employee Number, etc...',
                name: 'identity_card_number',
                label: 'Identity Card',
                bind: '{voterList.selection.identity_card}'
            }, {
                xtype: 'textfield',
                name: 'alternate_identity_card_number',
                tooltip: 'Citizen Card, Passport Card, Voter Card, PAN card, Drivers License, Passport, Tax Number, Employee Number, etc...',
                label: 'Alternate Identity Card',
                bind: '{voterList.selection.alternate_identity_card}'
            }, {
                xtype: 'textfield',
                name: 'access_code',
                label: 'Access Code',
                bind: '{voterList.selection.access_code}'
            }
        ]
    }]
});
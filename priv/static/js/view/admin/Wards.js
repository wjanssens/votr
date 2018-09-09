Ext.define('Votr.view.admin.Wards', {
    extend: 'Ext.Panel',
    alias: 'widget.admin.wards',
    requires: [
        'Votr.view.admin.WardsController'
    ],
    controller: 'admin.wards',
    padding: 0,
    layout: 'hbox',
    referenceHolder: true,
    viewModel: {
        stores: {
            wards: {
                type: 'tree',
                root: {
                    text: 'All',
                    expanded: true,
                    children: [
                        {text: 'Ward 1', description: 'Description 1', leaf: true},
                        {
                            text: 'Ward 2', description: 'Description 2', leaf: false, children:
                                [
                                    {text: 'Ward 21', description: 'Description 21', leaf: true},
                                    {text: 'Ward 22', description: 'Description 22', leaf: true},
                                ]
                        },
                        {text: 'Ward 3', description: 'Description 3', leaf: true},
                        {text: 'Ward 4', description: 'Description 4', leaf: true}
                    ]
                }
            }
        }
    },
    items: [{
        xtype: 'treelist',
        reference: 'wardList',
        width: 384,
        bind: '{wards}'
    }, {
        xtype: 'admin.ward',
        flex: 1
    }, {
        xtype: 'toolbar',
        itemId: 'toolbar',
        docked: 'bottom',
        items: [{
            xtype: 'button',
            itemId: 'addElection',
            text: 'Add Election',
            handler: 'onAddElection'
        }, {
            xtype: 'button',
            itemId: 'addWard',
            text: 'Add Ward',
            handler: 'onAddWard'
        }, '->', {
            xtype: 'button',
            itemId: 'voters',
            text: 'Voters',
            handler: 'onVoters'
        }, {
            xtype: 'button',
            itemId: 'ballots',
            text: 'Ballots',
            handler: 'onBallots'
        }, {
            xtype: 'button',
            itemId: 'save',
            text: 'Save',
            ui: 'action',
            handler: 'onSave'
        }]
    }]
});

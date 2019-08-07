Ext.define('Votr.view.admin.Result', {
    extend: 'Ext.panel.Panel',
    alias: 'widget.admin.result',
    layout: 'vbox',
    items: [
        {
            xtype: 'grid',
            title: 'Rounds',
            grouped: true,
            columns: [
                { text: 'Name', dataIndex: 'name', flex: 1},
                { text: 'Round', dataIndex: 'round', flex: 1 },
                { text: 'Votes', dataIndex: 'votes', flex: 1 },
                { text: 'Surplus', dataIndex: 'surplus', flex: 1 },
                { text: 'Received', dataIndex: 'received', flex: 1 },
                { text: 'Status', dataIndex: 'status', flex: 1}
            ],
            flex: 1,
            store: 'admin.Results'
        }
    ]
});
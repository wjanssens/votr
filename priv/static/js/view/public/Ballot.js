Ext.define('Votr.view.public.Ballot', {
    extend: 'Ext.Container',
    alias: 'widget.public.ballot',
    layout: 'vbox',
    padding: 0,
    items: [
        {
            xtype: 'grid',
            grouped: true,
            columns: [
                { text: 'Name', dataIndex: 'name', flex: 2},
                { text: 'Votes', dataIndex: 'votes', flex: 1 },
                { text: 'Surplus', dataIndex: 'surplus', flex: 1 },
                { text: 'Received', dataIndex: 'received', flex: 1 },
                { text: 'Status', dataIndex: 'status', flex: 1}
            ],
            flex: 1,
            store: 'Results'
        }
    ]
});
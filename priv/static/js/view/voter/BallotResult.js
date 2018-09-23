Ext.define('Votr.view.voter.BallotResult', {
    extend: 'Ext.panel.Panel',
    alias: 'widget.voter.ballotresult',
    layout: 'vbox',
    padding: 0,
    scrollable: true,
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
            store: 'voter.Results'
        }
    ]
});
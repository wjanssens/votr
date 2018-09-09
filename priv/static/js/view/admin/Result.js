Ext.define('Votr.view.admin.Result', {
    extend: 'Ext.panel.Panel',
    alias: 'widget.admin.result',
    layout: 'vbox',
    items: [
        {
            xtype: 'cartesian',
            width: '100%',
            flex: 1,
            insetPadding: 20,
            innerPadding: 20,
            store: 'Results',
            axes: [{
                type: 'numeric',
                position: 'left',
                title: {
                    text: 'Votes'
                },
                fields: 'votes',
                limits: [{
                    value: 26,
                    line: {
                        lineDash: [2, 2],
                        title: {
                            text: 'Quota: 26 votes'
                        }
                    }
                }]
            }, {
                type: 'category',
                position: 'bottom',
                title: {
                    text: 'Candidates'
                },
                fields: 'name'
            }],
            series: [{
                type: 'bar',
                highlight: true,
                xField: 'name',
                yField: 'votes',
                style: {
                    minGapWidth: 20
                },
                colors: ['#607D8B'],
                highlight: {
                    strokeStyle: 'black',
                    fillStyle: '#fd9726'
                },
                label: {
                    field: 'votes',
                    display: 'insideEnd'
                }
            }]
        },
        {
            xtype: 'grid',
            title: 'Rounds',
            columns: [
                { text: 'Name', dataIndex: 'name', flex: 1},
                { text: 'Round', dataIndex: 'round', flex: 1 },
                { text: 'Votes', dataIndex: 'votes', flex: 1 },
                { text: 'Surplus', dataIndex: 'surplus', flex: 1 },
                { text: 'Status', dataIndex: 'status', flex: 1}
            ],
            flex: 1,
            store: 'Results'
        }
    ]
});
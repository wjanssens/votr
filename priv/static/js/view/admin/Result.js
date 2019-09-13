Ext.define('Votr.view.admin.Result', {
    extend: 'Ext.panel.Panel',
    alias: 'widget.admin.result',
    layout: 'vbox',
    items: [
        {
            title: 'Results',
            xtype: 'cartesian',
            insetPadding: 20,
            innerPadding: 20,
            bind: '{resultRoundList.selection.candidates}',
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
                    text: 'Candidates'.translate()
                },
                fields: 'name'
            }],
            series: [{
                type: 'bar',
                stacked: true,
                highlight: true,
                xField: 'name',
                yField: ['votes','received'],
                style: {
                    minGapWidth: 20
                },
                colors: ['#607D8B', '#fd9726'],
                highlight: {
                    strokeStyle: 'black',
                    fillStyle: '#fd9726'
                },
                label: {
                    field: 'votes',
                    display: 'insideEnd'
                }
            }]
        }
    ]
});

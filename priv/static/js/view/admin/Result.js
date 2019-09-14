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
            flex: 1,
            bind: {
                store: {
                    model: 'Votr.model.admin.ResultCandidate',
                    data: '{resultRoundsList.selection.candidates}'
                }
            },
            axes: [{
                type: 'numeric',
                position: 'bottom',
                title: {
                    text: 'Votes'.translate()
                },
                fields: ['votes', 'temp'],
                limits: [{
                    bind: { value: '{resultRoundsList.selection.quota}' },
                    line: {
                        lineDash: [2, 2],
                        title: {
                            bind: { text: 'Quota: {resultRoundsList.selection.quota} votes' }
                        }
                    }
                }]
            }, {
                type: 'category',
                position: 'left',
                title: {
                    text: 'Candidates'.translate()
                },
                fields: 'name'
            }],
            flipXY: true,
            series: [{
                type: 'bar',
                highlight: true,
                xField: 'name',
                yField: ['temp','surplus','received'],
                style: {
                    minGapWidth: 20
                },
                colors: ['#607D8B', '#e91e63', '#91c34a'],
                highlight: {
                    strokeStyle: 'black',
                    fillStyle: '#fd9726'
                }
            }]
        }
    ]
});

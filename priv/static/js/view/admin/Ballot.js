Ext.define('Votr.view.admin.Ballot', {
    extend: 'Ext.form.Panel',
    alias: 'widget.admin.ballot',
    bind: {
        disabled: '{!ballotList.selection}'
    },
    layout: 'vbox',
    defaults: {
        margin: 0
    },
    items: [
        {
            layout: 'hbox',
            defaults: {
                margin: 10,
                shadow: true,
                flex: 1
            },
            items: [
                {
                    xtype: 'panel',
                    layout: 'hbox',
                    title: 'Candidates',
                    iconCls: 'x-fa fa-check-square',
                    padding: 0,
                    items: [
                        {
                            xtype: 'button',
                            width: '100%',
                            handler: 'onCandidates',
                            bind: {
                                html: '<span style="text-align: center; line-height: 1em; font-size: 24px;">{ballotList.selection.candidate_ct}</span>'
                            }
                        }
                    ]
                },
                {
                    xtype: 'panel',
                    layout: 'hbox',
                    flex: 1,
                    items: [
                        {
                            xtype: 'button',
                            handler: 'onResults',
                            bind: {
                                html: 'Results'
                            }
                        },
                    ]
                },
                {
                    xtype: 'panel',
                    layout: 'hbox',
                    title: 'Turnout',
                    iconCls: 'x-fa fa-percent',
                    style: 'text-align: center;',
                    bind: {
                        html: '<span style="font-size: 24px;">73%</span>'

                    }
                }
            ]
        },
        {
            xtype: 'panel',
            layout: 'hbox',
            padding: 0,
            defaults: {
                shadow: true,
                flex: 1,
                margin: 10
            },
            items: [
                {
                    xtype: 'panel',
                    layout: 'vbox',
                    items: [
                        {
                            xtype: 'panel',
                            layout: 'hbox',
                            padding: 0,
                            items: [{
                                xtype: 'textfield',
                                name: 'title',
                                label: 'Title'.translate(),
                                flex: 1,
                                bind: {
                                    value: '{title}',
                                    placeHolder: '{ballotList.selection.titles.default}'
                                }
                            }, {
                                xtype: 'selectfield',
                                label: 'Language',
                                width: 128,
                                bind: {
                                    store: '{languages}',
                                    value: '{language}'
                                }
                            }]
                        }, {
                            xtype: 'container',
                            layout: 'hbox',
                            padding: 0,
                            items: [{
                                xtype: 'textfield',
                                name: 'description',
                                label: 'Description *',
                                flex: 1,
                                bind: {
                                    value: '{description}',
                                    placeHolder: '{ballotList.selection.descriptions.default}'
                                }
                            }, {
                                xtype: 'selectfield',
                                label: 'Language',
                                width: 128,
                                store: 'Languages',
                                bind: {
                                    store: '{languages}',
                                    value: '{language}'
                                }
                            }]
                        }, {
                            xtype: 'textfield',
                            name: 'ext_id',
                            label: 'External ID',
                            bind: '{ballotList.selection.ext_id}'
                        }, {
                            xtype: 'selectfield',
                            label: 'Method *',
                            name: 'method',
                            options: [
                                {value: 'scottish_stv', text: 'Scottish STV'},
                                {value: 'meek_stv', text: 'Meek STV'},
                                {value: 'plurality', text: 'Plurality'},
                                {value: 'approval', text: 'Approval'}
                            ],
                            bind: '{method}'
                        }, {
                            xtype: 'selectfield',
                            label: 'Quota *',
                            queryMode: 'local',
                            name: 'quota',
                            options: [
                                {value: 'droop', text: 'Droop [ (v / (s + 1)) + 1 ]'},
                                {value: 'hare', text: 'Hare [ v / s ]'},
                                {value: 'imperator', text: 'Imperator [ v / (s + 2) ]'},
                                {value: 'hagenback-bischoff', text: 'Hagenbach Bischoff [ v / (s + 1) ]'},
                            ],
                            bind: '{quota}'
                        }, {
                            xtype: 'spinnerfield',
                            label: 'Electing',
                            minValue: 1,
                            value: 1,
                            stepValue: 1,
                            name: 'electing',
                            tooltip: 'How many candidates are being elected',
                            bind: '{ballotList.selection.electing}'
                        }, {
                            xtype: 'checkboxfield',
                            name: 'anonymous',
                            label: 'Anonymous',
                            value: 'anonymous',
                            checked: false,
                            tooltip: 'Results are anonymous',
                            bind: '{ballotList.selection.anonymous}'
                        }, {
                            xtype: 'checkboxfield',
                            name: 'shuffle',
                            label: 'Shuffle Candidates',
                            value: 'shuffle',
                            checked: false,
                            tooltip: 'Candidates are shown in a random order',
                            bind: '{ballotList.selection.shuffled}'
                        }, {
                            xtype: 'checkboxfield',
                            name: 'mutable',
                            label: 'Mutable',
                            value: 'mutable',
                            checked: false,
                            tooltip: 'Voters can change their vote',
                            bind: '{ballotList.selection.mutable}'
                        }, {
                            xtype: 'checkboxfield',
                            name: 'public',
                            label: 'Public Results',
                            value: 'public',
                            checked: false,
                            tooltip: 'Election results are public',
                            bind: '{ballotList.selection.public}'
                        }
                    ]
                },
                {
                    title: 'Results',
                    xtype: 'cartesian',
                    width: '100%',
                    flex: 1,
                    insetPadding: 20,
                    innerPadding: 20,
                    store: 'admin.Results',
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
        }
    ]
});
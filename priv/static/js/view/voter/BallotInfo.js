Ext.define('Votr.view.voter.BallotInfo', {
    extend: 'Ext.Container',
    alias: 'widget.voter.ballotinfo',
    layout: 'hbox',
    border: 0,
    padding: 0,
    scrollable: 'vertical',
    items: [
        {
            layout: 'vbox',
            xtype: 'formpanel',
            disabled: true,
            flex: 1,
            padding: 4,
            scrollable: false,
            items: [
                {
                    xtype: 'textfield',
                    label: 'Ward',
                    bind: '{ward}'
                }, {
                    xtype: 'textfield',
                    label: 'Start Date/Time',
                    bind: '{start:date("Y-m-d H:i:sO")}'
                }, {
                    xtype: 'textfield',
                    label: 'Candidate Order',
                    bind: '{order}'
                }, {
                    xtype: 'textfield',
                    label: 'Changes Allowed',
                    bind: '{mutableText}'
                }
            ]
        },
        {
            layout: 'vbox',
            xtype: 'formpanel',
            disabled: true,
            flex: 1,
            padding: 4,
            scrollable: false,
            items: [
                {
                    xtype: 'textfield',
                    label: 'Candidates Elected',
                    bind: '{electing}'
                }, {
                    xtype: 'textfield',
                    label: 'End Date/Time',
                    bind: '{end:date("Y-m-d H:i:sO")}'
                }, {
                    xtype: 'textfield',
                    label: 'Counting Method',
                    bind: '{methodName}'
                }, {
                    xtype: 'textfield',
                    label: 'Public Results',
                    bind: '{publicText}'
                }
            ]
        }
    ]
});
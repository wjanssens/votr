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
                    value: 'Test'
                }, {
                    xtype: 'textfield',
                    label: 'Start Date/Time',
                    value: '2018-01-01 14:00 -07:00'
                }, {
                    xtype: 'textfield',
                    label: 'Candidate Order',
                    value: 'Random'
                }, {
                    xtype: 'checkboxfield',
                    label: 'Mutable',
                    checked: false
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
                    value: '3'
                }, {
                    xtype: 'textfield',
                    label: 'End Date/Time',
                    value: '2018-03-01 14:00 -07:00'
                }, {
                    xtype: 'textfield',
                    label: 'Counting Method',
                    value: 'Scottish STV'
                }
            ]
        }
    ]
});
Ext.define('Votr.view.voter.BallotInfo', {
    extend: 'Ext.form.Panel',
    alias: 'widget.voter.ballotinfo',
    layout: 'vbox',
    border: 1,
    disabled: true,
    items: [
        {
            xtype: 'textfield',
            label: 'Ward'
        }, {
            xtype: 'textfield',
            label: 'Start Date/Time'
        }, {
            xtype: 'textfield',
            label: 'End Date/Time'
        }, {
            xtype: 'textfield',
            label: 'Counting Method'
        }, {
            xtype: 'textfield',
            label: 'Candidates Elected'
        }, {
            xtype: 'textfield',
            label: 'Candidate Order'
        }, {
            xtype: 'checkboxfield',
            label: 'Mutable',
            checked: false
        }
    ]
});
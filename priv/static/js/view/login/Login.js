Ext.define('Votr.view.login.Login', {
    extend: 'Ext.Panel',
    alias: 'widget.login',
    layout: 'hbox',
    requires: [
        "Votr.view.login.LoginController"
    ],
    controller: 'login',
    items: [{
        xtype: 'panel',
        flex: 1,
    }, {
        xtype: 'panel',
        width: 512,
        layout: 'vbox',
        items: [
            {
                xtype: 'panel',
                height: 64,
            },
            {
                xtype: 'panel',
                itemId: 'login_cards',
                border: 1,
                height: 384,
                layout: 'card',
                items: [{
                    xtype: 'formpanel',
                    title: 'Voter Login',
                    items: [{
                        xtype: 'textfield',
                        name: 'ballot_id',
                        label: 'Ballot ID'
                    },{
                        xtype : 'toolbar',
                        docked: 'bottom',
                        items: [{
                            xtype: 'button',
                            text: 'Officials Login',
                            handler: 'onOfficialsLogin'
                        }, '->', {
                            xtype: 'button',
                            text: 'Next',
                            handler: 'onVoterId'
                        }]
                    }]
                }, {
                    xtype: 'formpanel',
                    title: 'Voter Login',
                    items: [{
                        xtype: 'textfield',
                        name: 'challenge',
                        label: 'challenge'
                    },{
                        xtype: 'textfield',
                        name: 'response',
                        label: 'response'
                    },{
                        xtype : 'toolbar',
                        docked: 'bottom',
                        items: [{
                            xtype: 'button',
                            text: 'Back',
                            handler: 'onVoterLogin'
                        }, '->', {
                            xtype: 'button',
                            text: 'Next',
                            handler: 'onVoterCredentials'
                        }]
                    }]
                }, {
                    title: 'Election Official Login',
                    xtype: 'formpanel',
                    items: [{
                        xtype: 'textfield',
                        name: 'username',
                        label: 'Username'
                    }, {
                        xtype: 'passwordfield',
                        name: 'password',
                        label: 'Password'
                    }, {
                        xtype: 'checkboxfield',
                        name: 'keepmeloggedin',
                        label: 'Keep me logged in'
                    }, {
                        xtype : 'toolbar',
                        docked: 'bottom',
                        items: [{
                            xtype: 'button',
                            text: 'Back',
                            handler: 'onVoterLogin'
                        }, {
                            xtype: 'button',
                            text: 'Register',
                            handler: 'onRegister'
                        }, {
                            xtype: 'button',
                            text: 'Forgot Password',
                            handler: 'onForgotPassword'
                        },'->',{
                            xtype: 'button',
                            text: 'Log In',
                            handler: 'onOfficialCredentials'
                        }]
                    }]
                }, {
                    title: 'Register',
                    xtype: 'formpanel',
                    items: [{
                        xtype: 'textfield',
                        name: 'username',
                        label: 'Username',
                    }, {
                        xtype: 'emailfield',
                        name: 'email',
                        label: 'Email Address'
                    }, {
                        xtype: 'passwordfield',
                        name: 'password',
                        label: 'Password'
                    }, {
                        xtype: 'passwordfield',
                        name: 'retype_password',
                        label: 'Retype Password'
                    }, {
                        xtype: 'checkboxfield',
                        name: 'agreetoterms',
                        label: 'I agree with Terms and Conditions'
                    },{
                        xtype : 'toolbar',
                        docked: 'bottom',
                        items: [{
                            xtype: 'button',
                            text: 'Back',
                            handler: 'onOfficialsLogin'
                        }, '->', {
                            xtype: 'button',
                            text: 'Register',
                            handler: 'onRegister'
                        }]
                    }]
                }, {
                    title: 'Forgot Password',
                    xtype: 'formpanel',
                    items: [{
                        xtype: 'textfield',
                        name: 'identifier',
                        label: 'Username / Email'
                    }, {
                        xtype: 'passwordfield',
                        name: 'password',
                        label: 'Password'
                    }, {
                        xtype: 'passwordfield',
                        name: 'retype_password',
                        label: 'Retype Password'
                    }, {
                        xtype : 'toolbar',
                        docked: 'bottom',
                        items: [{
                            xtype: 'button',
                            text: 'Back',
                            handler: 'onOfficialsLogin'
                        }, '->', {
                            xtype: 'button',
                            text: 'Request Reset',
                            handler: 'onSendResetToken'
                        }]
                    }]
                }, {
                    title: 'Forgot Password',
                    xtype: 'formpanel',
                    items: [{
                        xtype: 'textfield',
                        name: 'token',
                        label: 'Token'
                    }, {
                        xtype: 'passwordfield',
                        name: 'password',
                        label: 'Password'
                    }, {
                        xtype: 'passwordfield',
                        name: 'retype_password',
                        label: 'Retype Password'
                    }, {
                        xtype : 'toolbar',
                        docked: 'bottom',
                        items: [{
                            xtype: 'button',
                            text: 'Back',
                            handler: 'onForgotPassword'
                        }, '->', {
                            xtype: 'button',
                            text: 'Reset',
                            handler: 'onResetPassword'
                        }]
                    }]
                }, {
                    title: 'Two Step Verification',
                    xtype: 'formpanel',
                    items: [{
                        xtype: 'textfield',
                        name: 'code',
                        label: 'Code'
                    }, {
                        xtype : 'toolbar',
                        docked: 'bottom',
                        items: [{
                            xtype: 'button',
                            text: 'Back',
                            handler: 'onOfficialsLogin'
                        }, '->', {
                            xtype: 'button',
                            text: 'Next',
                            handler: 'onMfaCode'
                        }]
                    }]
                }]
            }
        ]
    }, {
        xtype: 'panel',
        flex: 1,
    }]
});
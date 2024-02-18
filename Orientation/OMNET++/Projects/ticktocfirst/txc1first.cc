#include<string.h>
#include<omnetpp.h>

using namespace omnetpp;

class Txc1first:public cSimpleModule
{
protected:
    virtual void initialize() override;
    virtual void handleMessage(cMessage *msg) override;
};

Define_Module(Txc1first);

void Txc1first::initialize()
{
    if(strcmp("tic", getName()) == 0){
        EV << "Sending initial message\n";
        cMessage*msg = new cMessage("tictocMsg");
        send(msg, "out");
    }
}

void Txc1first::handleMessage(cMessage *msg)
{
    EV << "Recived message '" << msg->getName() <<"', sending it out again\n";
    send(msg,"out");
}

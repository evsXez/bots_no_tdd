const functions = require("firebase-functions");
const admin = require('firebase-admin');

class Response {
    constructor(status, body) {
        this.status = status;
        this.body = body;
      }
}

admin.initializeApp();
const express = require('express');
// const cors = require('cors');

const app = express();

// Automatically allow cross-origin requests
// app.use(cors({ origin: true }));


app.get('/', async (req, res) => await runRequest(res, () => getUsers()));
app.post('/', async (req, res) => await runRequest(res, () => createUser(req.body.name, req.body.comment)));
app.put('/', async (req, res) => await runRequest(res, () => updateUser(req.body.id, req.body.name, req.body.comment)));
app.delete('/', async (req, res) => await runRequest(res, () => deleteUser(req.body.id)));

exports.highfive = functions.https.onRequest(app);

async function runRequest(res, fun) {
    const request = await fun();
    res.status(request.status).header("Content-Type", "application/json").send(request.body);
}

async function getUsers() {
    const res = await admin.firestore().collection('hf_users').get();
    const array = res.docs.map((value, index, array) => {
        const obj = value.data();
        return {"id": value.id, "name": obj.name, "comment": obj.comment, "updated": value.updateTime.toMillis()};
    });
    return new Response(200, JSON.stringify(array));
}

async function createUser(name, comment) {
    const res = await admin.firestore().collection('hf_users').add({name: name, comment: comment});
    return new Response(201, JSON.stringify({"message":"Created", "id":res.id}));
}

async function updateUser(id, name, comment) {
    const doc = admin.firestore().collection('hf_users').doc(id);
    const obj = await doc.get();
    const isExists = obj.createTime != undefined

    if (isExists) {
        doc.set({name: name, comment: comment});
        return new Response(200, JSON.stringify({"message":"Updated"}));
    }
    return new Response(404, JSON.stringify({"message":"Not found"}));
}

async function deleteUser(id) {
    const doc = admin.firestore().collection('hf_users').doc(id);
    const obj = await doc.get();
    const isExists = obj.createTime != undefined

    if (isExists) {
        await doc.delete();
        return new Response(200, JSON.stringify({"message":"Deleted"}));
    }
    return new Response(404, JSON.stringify({"message":"Not found"}));
}


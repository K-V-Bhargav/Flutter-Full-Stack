const express = require("express");
const mongoose = require("mongoose");
const cors = require("cors");
const app = express();
const Person = require("./employee");

app.use(cors());
app.use(express.json());
app.use(express.urlencoded({
    extended: true
}));

mongoose.connect("mongodb://127.0.0.1:27017/test").
then(console.log("Connected to DataBase !!")),

// Post API
app.post("/api/add_person", async (req, res) => {
    console.log("Result: ", req.body);
    try {
        const data = new Person(req.body);
        const dataToStore = await data.save();
        res.status(200).json(dataToStore);
    } catch (error) {
        res.status(400).json({
            "status": error.message
        });
    }
});

// Get API
app.get("/api/get_person", async (req, res) => {
    try {
        const personData = await Person.find({});
        res.status(200).json({
            "Status Code": 200,
            "person": personData
        });
    } catch (error) {
        res.status(500).json({
            "Status Code": 500,
            "Message": "Internal Server Error",
        });
    }
});

// Update API
app.put("/api/update/:id", async (req, res) => {
    const id = req.params.id;
    try {
        const data = await Person.findByIdAndUpdate(id, req.body, { new: true });
        if (!data) {
            return res.status(404).json({
                status: 404,
                message: "Person not found",
            });
        }
        res.status(200).json({
            status: 200,
            message: "Person Updated Successfully !!",
            updatedPerson: data,
        });
    } catch (error) {
        console.error(error);
        res.status(500).json({
            status: 500,
            message: "Internal Server Error",
            error: error.message,
        });
    }
});

// Delete API
app.delete("/api/delete/:id", async (req, res) => {
    try {
        const id = req.params.id;
        const deletedPerson = await Person.findByIdAndDelete(id);
        if (!deletedPerson) {
            return res.status(404).json({
                "Status Code": 404,
                "Message": "Person not found",
            });
        }
        res.status(200).json({
            "Status Code": 200,
            "Message": "Person Deleted Successfully !!",
            "Deleted Person": deletedPerson,
        });
    } catch (error) {
        res.status(500).json({
            "Status Code": 500,
            "Message": "Internal Server Error",
        });
    }
});

const port = 8000;
app.set("port", port);
app.listen(port, () => {
    console.log(`Successfully connected to port: ${port}`);
});

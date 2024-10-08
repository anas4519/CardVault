const { Router } = require("express");
const multer = require("multer");
const path = require("path");
const fs = require("fs");
const { Card } = require("../models/card");
const { User } = require("../models/user");
const cloudinary = require("cloudinary").v2;
const { CloudinaryStorage } = require("multer-storage-cloudinary");

// const storage = multer.diskStorage({
//   destination: function (req, file, cb) {
//     cb(null, path.resolve(`./public/cards/`));
//   },
//   filename: function (req, file, cb) {
//     const fileName = `${Date.now()}-${file.originalname}`;
//     cb(null, fileName);
//   },
// });

cloudinary.config({
  cloud_name: process.env.CLOUDINARY_CLOUD_NAME,
  api_key: process.env.CLOUDINARY_API_KEY,
  api_secret: process.env.CLOUDINARY_API_SECRET,
});

const storage = new CloudinaryStorage({
  cloudinary: cloudinary,
  params: {
    folder: "cards",
    allowedFormats: ["jpg", "jpeg", "png"],
    public_id: (req, file) => `${Date.now()}-${file.originalname}`,
  },
});

const upload = multer({ storage: storage });
const router = Router();

router.post("/", upload.single("cardImage"), async (req, res) => {
  if (!req.file) {
    return res
      .status(400)
      .json({ success: false, message: "No file uploaded" });
  }

  const {
    name,
    industry,
    sector,
    companyName,
    venue,
    date,
    designation,
    companyAddress,
    personalAddress,
    email,
    website,
    telephone,
    mobile,
    whatsapp,
    category,
    user_id,
    initialNotes,
    additionalNotes,
  } = req.body;

  try {
    const user = await User.findById(user_id);
    if (!user) {
      return res
        .status(404)
        .json({ success: false, message: "User not found" });
    }

    const card = await Card.create({
      name,
      industry,
      sector,
      companyName,
      venue,
      date,
      designation,
      companyAddress,
      personalAddress,
      email,
      website,
      telephone,
      mobile,
      whatsapp,
      category,
      initialNotes,
      additionalNotes,
      createdBy: user._id,
      cardImage: req.file.path, // Cloudinary URL
    });

    return res.json({ success: true, card });
  } catch (error) {
    console.error(error);
    return res
      .status(500)
      .json({ success: false, message: "Failed to create card" });
  }
});

router.get("/user/:createdBy", async (req, res) => {
  try {
    const { createdBy } = req.params;

    if (!createdBy) {
      return res.status(400).json({ error: "Invalid user ID" });
    }

    const allCards = await Card.find({ createdBy }).sort({ createdAt: -1 });

    if (!allCards || allCards.length === 0) {
      return res.status(404).json({ message: "No cards found for this user" });
    }

    return res.json(allCards);
  } catch (error) {
    console.error("Error fetching cards:", error);
    return res.status(500).json({ error: "Internal server error" });
  }
});

router.delete("/:id", async (req, res) => {
  const { id } = req.params;

  try {
    const card = await Card.findById(id);
    if (!card) {
      return res
        .status(404)
        .json({ success: false, message: "Card not found" });
    }

    const cardImageUrl = card.cardImage;
    const imagePublicId = cardImageUrl
      .split("/")
      .slice(-2)
      .join("/")
      .replace(/\.[^/.]+$/, "");

    cloudinary.uploader.destroy(imagePublicId, async (error, result) => {
      if (error) {
        console.error("Error deleting image from Cloudinary:", error);
        return res.status(500).json({
          success: false,
          message: "Failed to delete image from Cloudinary",
        });
      }

      try {
        // Delete the card from the database
        const deletedCard = await Card.findByIdAndDelete(id);
        return res.json({
          success: true,
          message: "Card and image deleted successfully",
        });
      } catch (error) {
        console.error("Error deleting card:", error);
        return res
          .status(500)
          .json({ success: false, message: "Failed to delete card" });
      }
    });
  } catch (error) {
    console.error("Error deleting card:", error);
    return res
      .status(500)
      .json({ success: false, message: "Failed to delete card" });
  }
});

router.patch("/:id/initialNotes", async (req, res) => {
  const { id } = req.params;
  const { initialNotes } = req.body;
  try {
    const updatedCard = await Card.findByIdAndUpdate(
      id,
      { initialNotes: initialNotes },
      { new: true }
    );
    if (!updatedCard) {
      return res.status(404).json({ message: "Card not found" });
    }
    res.status(200).json(updatedCard);
  } catch (error) {
    res.status(500).json({ message: "Server error", error });
  }
});

router.patch("/:id/additionalNotes", async (req, res) => {
  const { id } = req.params;
  const { additionalNotes } = req.body;

  try {
    const updatedCard = await Card.findByIdAndUpdate(
      id,
      { additionalNotes: additionalNotes },
      { new: true }
    );
    if (!updatedCard) {
      return res.status(404).json({ message: "Card not found" });
    }
    res.status(200).json(updatedCard);
  } catch (error) {
    res.status(500).json({ message: "Server error", error });
  }
});

module.exports = router;

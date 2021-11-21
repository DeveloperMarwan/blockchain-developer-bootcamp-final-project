import { PageHeader } from "antd";
import React from "react";

// displays a page header

export default function Header() {
  return (
    <a
      href="https://github.com/DeveloperMarwan/blockchain-developer-bootcamp-final-project"
      target="_blank"
      rel="noopener noreferrer"
    >
      <PageHeader
        title="DeveloperMarwan"
        subTitle="Consensys Blockchain Developer Bootcamp Final Project (2021)"
        style={{ cursor: "pointer" }}
      />
    </a>
  );
}

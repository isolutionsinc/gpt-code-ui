import AssistantIcon from '@mui/icons-material/Assistant';

import "./Sidebar.css";

export default function Sidebar(props: any) {
  const handleOpenAIButtonClick = () => {
    const key = prompt("Please enter your OpenAI key", props.openAIKey);
    if (key != null) {
      props.setOpenAIKey(key);
    }
  };
  return (
    <>
      <div className="sidebar">
        <div className="logo">
          <AssistantIcon /> Cherry Lake Demo
        </div>
        <div className="settings">
          <div style={{ marginBottom: '8px' }}>
            <label htmlFor="userPersona" style={{ display: 'block' }}>
              User Persona:
            </label>
            <textarea
              id="userPersona"
              style={{ width: '100%' }}
              value={props.userPersona}
              onChange={(e)=> props.setUserPersona(e.target.value)}
            />
          </div>
          <div style={{ marginBottom: '8px' }}>
            <label htmlFor="audiencePersona" style={{ display: 'block' }}>
              Audience Persona:
            </label>
            <textarea
              id="audiancePersona"
              style={{ width: '100%' }}
              value={props.audiancePersona}
              onChange={(e)=> props.setAudiancePersona(e.target.value)}
            />
          </div>
        </div>
      </div>
    </>
  );
}
